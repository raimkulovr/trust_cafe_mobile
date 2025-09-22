import 'package:flutter/material.dart';

class ReducedLogoBrown extends StatelessWidget {
  const ReducedLogoBrown({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: SizedBox(
        height: Theme.of(context).appBarTheme.toolbarHeight ?? 56,
        child: Image.asset('assets/images/logo-reduced-${colorScheme.brightness==Brightness.light ? 'brown' : 'white'}.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}