import 'package:flutter/material.dart';
import 'package:refresher/constants/color_scheme.dart';

class AppButton extends StatelessWidget {
  final Function() onPressed;
  final String buttonText;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(buttonText, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
