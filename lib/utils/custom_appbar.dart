// lib/utils/custom_appbar.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:salonika/features/cart/view/cart.dart';
import 'package:salonika/features/cart/view/widgets/cart_badge.dart';
import 'package:salonika/features/profile/view/profile_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String _sanitizeEmailKey(String email) =>
      email.replaceAll('.', '_').replaceAll('@', '_');

  Future<String> _fetchFullName() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user == null) return 'Guest';

    final db = FirebaseDatabase.instance.ref();

    // 1) Try users/<uid>/fullName
    if (user.uid.isNotEmpty) {
      final snap = await db.child('users/${user.uid}/fullName').get();
      final val = snap.value;
      if (val is String && val.trim().isNotEmpty) return val.trim();
    }

    // 2) Fallback: users/<sanitizedEmail>/fullName (legacy path)
    final email = user.email;
    if (email != null) {
      final key = _sanitizeEmailKey(email);
      final snap = await db.child('users/$key/fullName').get();
      final val = snap.value;
      if (val is String && val.trim().isNotEmpty) return val.trim();
    }

    // 3) Last resort: displayName or email username
    if ((user.displayName ?? '').trim().isNotEmpty)
      return user.displayName!.trim();
    if (email != null && email.contains('@')) return email.split('@').first;
    return 'User';
  }

  String _firstName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.isNotEmpty ? parts.first : fullName;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      title: FutureBuilder<String>(
        future: _fetchFullName(),
        builder: (context, snap) {
          final name = snap.data;
          final greeting = name == null ? 'Hi' : 'Hi, ${_firstName(name)}';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              const Text(
                'Welcome back',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          );
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            children: [
              const SizedBox(width: 8),
              CartBadgeButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartDetails()),
                  );
                },
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
