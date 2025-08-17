import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:salonika/features/cart/view/cart.dart';
import 'package:salonika/features/cart/view/widgets/cart_badge.dart';
import 'package:salonika/features/profile/view/profile_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [const Text('Hi')],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton.filledTonal(
                icon: Icon(IconlyBroken.notification, size: 28),
                onPressed: () {
                  // Handle notifications
                },
              ),

              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CartBadgeButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartDetails()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
      leading: IconButton.filledTonal(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        },
        icon: const Icon(IconlyBroken.profile, color: Colors.black),
      ),
    );
  }
}
