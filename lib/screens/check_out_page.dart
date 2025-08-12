import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:salonika/utils/payment_method_selector.dart';
import 'package:salonika/widgets/edit_address_bottomsheet.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool isChecked = false;
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController addressController = TextEditingController(
    text: "",
  );
  final TextEditingController phoneController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton.filledTonal(
                  icon: Icon(IconlyBroken.bag, size: 28),
                  onPressed: () {},
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: const Text(
                      "3",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Shipping Address",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enter Delivery Address",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isChecked
                                  ? Colors.green
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            shape: const CircleBorder(),
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            side: BorderSide.none,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const Text(
                          "Home",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 30),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return EditAddressBottomSheet(
                                  nameController: nameController,
                                  addressController: addressController,
                                  phoneController: phoneController,
                                  onSave: () {
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      nameController.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      addressController.text,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      phoneController.text,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PaymentMethodSelector(
                initialMethod: PaymentMethod.creditCard,
                onChanged: (method) {
                  // Save selected payment method or update state
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Order Summary",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Items in Cart",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    // Here you would typically list the items in the cart
                    // For demonstration, we will use a placeholder
                    const Text(
                      "1x Product Name - \$20.00",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "2x Another Product - \$30.00",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total", style: TextStyle(fontSize: 16)),
                        const Text("\$50.00", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Handle order confirmation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Order Confirmed!")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Confirm Order",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
