import 'dart:math';

import 'package:flutter/material.dart';

class TcmBottomSheet extends StatefulWidget {
  const TcmBottomSheet({required this.child, this.maxHeight = 0.7, super.key})
    : assert(maxHeight>0 && maxHeight<=1);

  final Widget child;
  ///Max height in %. Must be >0 and <=1
  final double maxHeight;
  @override
  State<TcmBottomSheet> createState() => _TcmBottomSheetState();
}

class _TcmBottomSheetState extends State<TcmBottomSheet>
    with SingleTickerProviderStateMixin{

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      animationController: _animationController,
      onClosing: () {  },
      builder: (context) =>
          SingleChildScrollView(
            child: ClipPath(
              clipper: _TopClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height*widget.maxHeight,
                // padding: MediaQuery.of(context).viewInsets,
                child: widget.child,
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}


class _TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {

    const radius = 50.0;

    Path path = Path()
      ..moveTo(0, radius)
      ..arcTo(
          Rect.fromPoints(const Offset(0, 0), const Offset(radius, radius)), pi, 0.5 * pi, false)
      ..lineTo(size.width - radius, 0)
      ..arcTo(
          Rect.fromPoints(Offset(size.width - radius, 0), Offset(size.width, radius)), 1.5 * pi, 0.5 * pi, false)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}