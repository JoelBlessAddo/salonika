import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salonika/core/repo/service_repo.dart';
import 'package:salonika/features/services/view/widgets/thanks.dart';

// import your ThankYou page:
import 'package:salonika/utils/thank_you_page.dart';
import 'package:url_launcher/url_launcher.dart'; // adjust path if needed

class ServiceRequestPage extends StatefulWidget {
  const ServiceRequestPage({super.key});

  @override
  State<ServiceRequestPage> createState() => _ServiceRequestPageState();
}

class _ServiceRequestPageState extends State<ServiceRequestPage> {
  final _formKey = GlobalKey<FormState>();
  static const _shopNumber = '0545755752';
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final List<String> services = const [
    'Tractor Maintenance & Repair',
    'Tractor Financing Assistance',
    'Operator Training',
    'Spare Parts Ordering',
    'Tractor Delivery Service',
    'Rental Services',
  ];

  String? selectedService;
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _submitting = false;

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => selectedImage = File(image.path));
  }

  Future<void> submitRequest() async {
    final formOk = _formKey.currentState?.validate() ?? false;
    if (!formOk) return;
    if (selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please select a service'),
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final repo = ServiceRequestRepository();
      final requestId = await repo.submitServiceRequest(
        fullName: fullnameController.text.trim(),
        location: locationController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        service: selectedService!,
        attachment: selectedImage,
      );

      if (!mounted) return;

      // Navigate to your Thank You page (use the one you said is already built)
      // If your ThankYou supports an id, pass it. Otherwise just push it.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ThankYouService(
            orderId: '',
          ), // or ThankYou(orderId: requestId)
        ),
      );

      // Optional: clear form after navigation if you come back
      fullnameController.clear();
      locationController.clear();
      phoneController.clear();
      emailController.clear();
      setState(() {
        selectedService = null;
        selectedImage = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text('Failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _callShop() async {
    final uri = Uri(scheme: 'tel', path: _shopNumber);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to open dialer')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Request Services',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              icon: const Icon(IconlyBroken.call),
              onPressed: () {
                _callShop();
              },
            ),
          ),
        ],
      ),
      body: AbsorbPointer(
        absorbing: _submitting,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: fullnameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Enter full name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Enter location' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter phone number';
                        if (!RegExp(r'^\+?\d{7,15}$').hasMatch(v))
                          return 'Enter valid phone number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter email';
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(v))
                          return 'Enter valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Service',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedService,
                      items: services
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => selectedService = v),
                      validator: (v) =>
                          v == null ? 'Please select a service' : null,
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.upload_file,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Tap to upload an image (optional)',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : submitRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _submitting ? 'Submitting...' : 'Request Service',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_submitting)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x55FFFFFF),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
