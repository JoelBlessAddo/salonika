// lib/features/profile/view/about_page.dart
import 'package:flutter/material.dart';
import 'package:salonika/utils/bottom_nav.dart';
import 'package:salonika/utils/navigator.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  static const _shopLocalGh = '0545755752'; // user-facing number

  /// Convert local GH number like 0545755752 -> +233545755752
  String _toE164Gh(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) {
      return '+233${digits.substring(1)}';
    }
    if (digits.startsWith('233')) {
      return '+$digits';
    }
    if (digits.startsWith('+')) return digits;
    // Fallback assume GH
    return '+233$digits';
  }

  Future<void> _callShop() async {
    final uri = Uri(scheme: 'tel', path: _shopLocalGh);
    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Unable to open dialer')));
      }
    }
  }

  Future<void> _openWhatsApp() async {
    final phone = _toE164Gh(_shopLocalGh); // +233545755752
    final msg = Uri.encodeComponent(
      "Hello WAATCO 👋🏾\nI’d like to make an inquiry.",
    );
    final deepLink = Uri.parse('whatsapp://send?phone=$phone&text=$msg');
    final universal = Uri.parse(
      'https://wa.me/${phone.replaceAll('+', '')}?text=$msg',
    );

    // Prefer deep link if WhatsApp installed, else open universal link
    final okDeep = await canLaunchUrl(deepLink);
    final okUni = await canLaunchUrl(universal);

    final target = okDeep ? deepLink : universal;
    final success = await launchUrl(
      target,
      mode: LaunchMode.externalApplication,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open WhatsApp')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const company = 'WEST AFRICA AGROTECH COMPANY GHANA LIMITED (WAATCO)';
    const body =
        "is a sole distributor for SONALIKA’ Brand Tractors, Farm Implements and ‘Kirloskar Green’ Brand Diesel Generators, Pumps and Engines in Ghana and globally used over 80 countries including 40 countries in Africa.\n\n"
        "Their SONALIKA Brand Tractors and Farm Implements sold and serviced in the country are easy to operate and minimal maintenance (Service).\n\n"
        "They distribute the world's best agricultural machinery, including SONALIKA tractors, Kirloskar generators, Backhoe loaders, and a wide range of agricultural mechanization solutions and technology.";
    const address =
        "Opposite Nogahill Hotel, Dzorwulu, George Walker Bush Motorway (N1) Accra, Ghana";
    const contactName = "Henry";
    const contactRole = "Customer Service Manager";
    const phonePretty = "+233 54 575 5752";

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () =>
              customNavigator(context, const BottomNav(pageIndex: 3)),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              company,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            const Text(body, style: TextStyle(fontSize: 14, height: 1.4)),
            const SizedBox(height: 18),
            const Text(
              'Address',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(address),
            const SizedBox(height: 18),
            const Text(
              'Contact',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text("$contactName • $contactRole"),
            const SizedBox(height: 4),
            const Text(phonePretty),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _callShop,
                    child: const Text('Call'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _openWhatsApp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Message',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
