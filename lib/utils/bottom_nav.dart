import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:salonika/features/cart/view/cart_page.dart';
import 'package:salonika/features/home/view/home_page.dart';
import 'package:salonika/features/profile/view/profile_page.dart';
import 'package:salonika/features/services/view/services_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final pages = [
    const HomePage(),
    const Servicespage(),
    const CartPage(),
    const ProfilePage(),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(IconlyBold.home),
            icon: Icon(IconlyBroken.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(IconlyBold.setting),
            icon: Icon(IconlyBroken.setting),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(IconlyBold.bag),
            icon: Icon(IconlyBroken.bag),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(IconlyBold.profile),
            icon: Icon(IconlyBroken.profile),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
