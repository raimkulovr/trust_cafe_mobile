import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UnknownTrustIcon extends StatelessWidget {
  const UnknownTrustIcon({
    this.height,
    super.key});

  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SvgPicture.asset(
      colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
      height: height,
      'assets/icons/trust_unknown.svg',
    );
  }
}
