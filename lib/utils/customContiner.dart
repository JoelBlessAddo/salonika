import 'package:flutter/material.dart';
import 'package:salonika/utils/colors.dart';
import 'package:salonika/utils/textStyles.dart';
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: backgroundColor ?? GREEN, // 👈 dynamic color
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: CONTAINEERTEXT.copyWith(
            color: textColor ?? Colors.white, // 👈 dynamic text color
          ),
        ),
      ),
    );
  }
}
