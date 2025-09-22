import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TrunkIcon extends StatelessWidget {
  const TrunkIcon({
    this.color,
    this.height,
    super.key,
  });

  final Color? color;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      height: height ?? 10,
      colorFilter: ColorFilter.mode(color ?? Colors.white, BlendMode.srcIn),
      'assets/icons/trunk.svg',
    );
  }
}
