// lib/features/profile/view/about_page.dart
import 'package:flutter/material.dart';
import 'package:salonika/utils/bottom_nav.dart';
import 'package:salonika/utils/navigator.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
    const phone = "+233 54 575 5272";

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            customNavigator(context, BottomNav(pageIndex: 3));
          },
          icon: Icon(Icons.arrow_back_ios),
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
            Text(body, style: const TextStyle(fontSize: 14, height: 1.4)),
            const SizedBox(height: 18),
            const Text(
              'Address',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(address),
            const SizedBox(height: 18),
            const Text(
              'Contact',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text("$contactName • $contactRole"),
            const SizedBox(height: 4),
            Text(phone),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      /* TODO: add tel: launcher */
                    },
                    child: const Text('Call'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      /* TODO: add WhatsApp / email */
                    },
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
