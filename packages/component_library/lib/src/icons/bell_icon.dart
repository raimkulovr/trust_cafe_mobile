import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BellIcon extends StatelessWidget {
  const BellIcon(this.newComments, {super.key});

  final int newComments;

  @override
  Widget build(BuildContext context) {
    final Color color = newComments>0 ? Colors.pink : Colors.grey;
    return Row(
      children: [
        SvgPicture.asset(
          height: 20,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          'assets/icons/bell.svg',
        ),
        const SizedBox(width: 4,),
        Text('$newComments', style: TextStyle(color: color),),
      ],
    );
  }
}
