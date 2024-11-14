import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../colors.dart';

class VoteIcon extends StatelessWidget {
  const VoteIcon({
    required this.onPressed,
    this.isDown = false,
    this.height = 16,
    this.color,
    super.key,
  });

  final double height;
  final Color? color;
  final bool isDown;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Transform.flip(
        flipY: isDown,
        child: CustomPaint(
            size: Size.fromHeight(height),
            painter: CirclePainter(color: Colors.white),
            child: SvgPicture.asset(
              height: height,
              colorFilter: ColorFilter.mode(color == null ? TcmColors.voteIconColor : color!, BlendMode.srcIn),
              'assets/icons/upvote.svg',
            ),

        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final Color color;

  CirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(size.center(Offset.zero), size.width*0.9 / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}