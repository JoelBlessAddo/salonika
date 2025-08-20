import 'package:flutter/material.dart';

class InitialsAvatar extends StatelessWidget {
  final String name;
  final String email;
  final double radius;

  const InitialsAvatar({
    required this.name,
    required this.email,
    this.radius = 40,
  });

  String _initials() {
    String source = name.trim().isNotEmpty ? name.trim() : email.split('@').first;
    // Split by spaces, remove empties
    final parts = source.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();

    if (parts.length >= 2) {
      return (parts.first[0] + parts.last[0]).toUpperCase();
    } else if (parts.isNotEmpty) {
      final first = parts.first;
      final second = first.length > 1 ? first[1] : first[0];
      return (first[0] + second).toUpperCase();
    }
    return '?';
  }

  Color _bgColor(BuildContext context) {
    final seed = (name.isNotEmpty ? name : email).toLowerCase();
    final palette = <MaterialColor>[
      Colors.indigo,
      Colors.blue,
      Colors.teal,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.brown,
      Colors.cyan,
      Colors.deepOrange,
    ];
    final idx = seed.hashCode.abs() % palette.length;
    return palette[idx].shade400;
  }

  @override
  Widget build(BuildContext context) {
    final text = _initials();
    return CircleAvatar(
      radius: radius,
      backgroundColor: _bgColor(context),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: radius * 0.6, // scales text with radius
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
