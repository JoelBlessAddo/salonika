// lib/features/cart/view/widgets/cart_badge_button.dart
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salonika/core/repo/cart_repo.dart';


class CartBadgeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double top;
  final double right;

  const CartBadgeButton({
    super.key,
    required this.onPressed,
    this.top = -2,
    this.right = -2,
  });

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final repo = CartRepository();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton.filledTonal(
          icon: const Icon(IconlyBroken.bag, size: 28),
          onPressed: onPressed,
        ),
        Positioned(
          right: right,
          top: top,
          child: StreamBuilder<int>(
            stream: repo.cartCountStream(uid),
            builder: (context, snap) {
              final count = snap.data ?? 0;
              if (count <= 0) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
