import 'package:flutter/material.dart';

class StageSwitchButton extends StatefulWidget {
  const StageSwitchButton({super.key,
    required this.onPressed,
    required this.isPublish,
  });

  final VoidCallback? onPressed;
  final bool isPublish;

  @override
  State<StageSwitchButton> createState() => _StageSwitchButtonState();
}

class _StageSwitchButtonState extends State<StageSwitchButton> {
  late bool isEnabled;

  @override
  void initState() {
    super.initState();
    setIsEnabled();
  }

  void setIsEnabled(){
    isEnabled = !widget.isPublish;
    if(widget.isPublish){
      isEnabled = false;
      Future.delayed(const Duration(seconds: 1)).then((value) {
        if(mounted)
          setState(() {
            isEnabled=true;
          });
      },);
    } else {
      isEnabled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isEnabled ? widget.onPressed : null,
      child: Text(widget.isPublish
          ? 'Publish'
          : 'Next'),
    );
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    setIsEnabled();
  }
}
