// lib/features/cart/view/thank_you_page.dart
import 'package:flutter/material.dart';
import 'package:salonika/features/cart/view/widgets/order_details.dart';
import 'package:salonika/utils/bottom_nav.dart';

class ThankYouService extends StatelessWidget {
  final String orderId;
  const ThankYouService({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 100,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Thank You for\nmarking a request!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, color: Colors.green),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'We will attend to you in 2 working days',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const BottomNav()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
