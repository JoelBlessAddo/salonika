// lib/features/cart/view/thank_you_page.dart
import 'package:flutter/material.dart';
import 'package:salonika/features/cart/view/widgets/order_details.dart';
import 'package:salonika/utils/bottom_nav.dart';


class ThankYou extends StatelessWidget {
  final String orderId;
  const ThankYou({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.check_circle, size: 100, color: Colors.green),
                const SizedBox(height: 20),
                const Text('Thank You for\nShopping with us!',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 24, color: Colors.green)),
                const SizedBox(height: 10),
                Text(
                  'Your order #$orderId is confirmed and in processing.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Need Assistance? Our support team is here to help.',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsPage(orderId: orderId)));
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                side: BorderSide(color: Colors.grey.shade400, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("View Order Details", style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(height: 12),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Continue Shopping", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ]),
        const SizedBox(height: 20),
      ]),
    );
  }
}
