// lib/utils/auth_guard.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salonika/features/auth/login/view/login.dart';

Future<String?> ensureSignedIn(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) return user.uid;

  final go = await showDialog<bool>(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      title: const Text('Sign in required'),
      content: const Text('You need to sign in to use this feature.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogCtx).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(dialogCtx).pop(true),
          child: const Text('Sign In'),
        ),
      ],
    ),
  );

  if (go == true && context.mounted) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const Login()));
  }
  return null;
}
