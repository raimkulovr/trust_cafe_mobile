import 'package:flutter/material.dart';

class TcmPrimaryButton extends StatelessWidget {
  const TcmPrimaryButton({
    required this.onPressed,
    required this.text,
    this.bold = true,
    this.textColor,
    super.key,
  });

  final VoidCallback onPressed;
  final String text;
  final bool bold;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton(onPressed: onPressed, style: ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,
      overlayColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ), child: Text(text, style: TextStyle(color: textColor ?? colorScheme.onPrimary, fontWeight: bold ? FontWeight.bold : null),),);
  }
}
