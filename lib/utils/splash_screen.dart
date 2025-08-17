// lib/utils/splash_screen.dart
// ignore_for_file: deprecated_member_use
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salonika/features/auth/login/view/login.dart';
import 'package:salonika/utils/bottom_nav.dart';
import 'package:salonika/utils/colors.dart';

class SplashScreeen extends StatefulWidget {
  const SplashScreeen({super.key});

  @override
  State<SplashScreeen> createState() => _SplashScreeenState();
}

class _SplashScreeenState extends State<SplashScreeen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _goNext());
  }

  Future<void> _goNext({bool skipDelay = false}) async {
    if (!skipDelay) {
      // tiny delay so splash is visible
      await Future.delayed(const Duration(milliseconds: 12200));
    }

    if (!mounted || _navigated) return;
    _navigated = true;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // already signed in -> Home (tab 0)
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BottomNav(pageIndex: 0)),
        (route) => false,
      );
    } else {
      // not signed in -> Login
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/app.jpeg', fit: BoxFit.cover),
          ),
          Positioned(
            top: screenHeight * 0.05,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Center(
                child: Text(
                  "WAATCO\nWhere Technology Meets the Land",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: WHITE,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.05,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: () => _goNext(skipDelay: true),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  backgroundColor: Colors.black.withOpacity(0.7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
