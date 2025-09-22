import 'package:flutter/material.dart';

class FollowingButton extends StatelessWidget {
  const FollowingButton({
    required this.isFollowing,
    required this.onTap,
    super.key,
  });

  final bool isFollowing;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: isFollowing ? Colors.grey : Colors.yellow,
      ),
      child: InkWell(
        radius: 6,
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: SizedBox(
          height: 30,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Center(child: Row(
              children: [
                Text('${isFollowing?'un':''}follow', style: TextStyle(color: isFollowing ? Colors.white : Colors.black)),
                // const SizedBox(width: 2,),
                // Icon(isFollowing? Icons.star : Icons.star_border, size: 14, color: Colors.black)
              ],
            )),
          ),
        ),
      ),
    );
  }
}
