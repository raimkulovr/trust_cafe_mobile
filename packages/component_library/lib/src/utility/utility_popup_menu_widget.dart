import 'package:flutter/material.dart';

class PopupMenuWidget<T> extends PopupMenuEntry<T> {
  const PopupMenuWidget({
    super.key,
    required this.height,
    required this.child,
  });
  final Widget child;

  @override
  final double height;

  @override
  _PopupMenuWidgetState createState() => _PopupMenuWidgetState();

  @override
  bool represents(T? value) => false;
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  @override
  Widget build(BuildContext context) => widget.child;
}