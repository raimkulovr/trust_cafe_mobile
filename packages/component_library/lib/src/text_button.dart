import 'package:flutter/material.dart';

class TcmTextButton extends StatelessWidget {
  const TcmTextButton({super.key,
    required this.onTap,
    this.icon,
    this.text,
    this.child,
    this.isRow = true,
  }) : assert(text!=null || child!=null, 'Either [text] or [child] must be provided.');

  final VoidCallback onTap;
  final IconData? icon;
  final String? text;
  final Widget? child;
  final bool isRow;

  @override
  Widget build(BuildContext context) {
    final children = [
      if(icon!=null) Padding(
        padding: EdgeInsets.only(right: isRow ? 4 : 0),
        child: Icon(icon),
      ),
      // const SizedBox(width: 4,),
      text!=null
          ? Text(text!, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),)
          : child!,
      if(!isRow) const SizedBox(height: 4,)
    ];

    return FittedBox(
      child: InkWell(
        radius: 6,
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        onLongPress: (){},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: isRow
              ? Row(children: children,)
              : Column(children: children,),
        ),
      ),
    );
  }

}

class TcmShowMarkedContentButton extends StatelessWidget {
  const TcmShowMarkedContentButton({
    required this.onTap,
    required this.blurLabel,
    this.isPost = true,
    super.key,
  });

  final bool isPost;
  final VoidCallback onTap;
  final String blurLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
      child: Center(
        child: TcmTextButton(
          isRow: false,
          onTap: onTap,
          icon: Icons.remove_red_eye_rounded,
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
                  children: [
                    TextSpan(text: 'This ${isPost? 'post':'comment'} has been marked as: '),
                    TextSpan(text: blurLabel, style: TextStyle(color: colorScheme.onSurface, decoration: TextDecoration.underline)),
                    const TextSpan(text: '.\nTap to reveal.'),
                  ])),
        ),
      ),
    );
  }

}
