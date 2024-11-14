import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'icons/vote_icon.dart';

typedef VoteCastCallback = Future<void> Function({bool? isUpvote});

class VoteCastWidget extends StatelessWidget {
  const VoteCastWidget({
    required this.onVoteCast,
    required this.voteValueSum,
    required this.voteCount,
    this.isUpvoted,
    super.key,
  });

  final VoteCastCallback? onVoteCast;
  final bool? isUpvoted;
  final int voteValueSum;
  final int voteCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final voteIconColor = colorScheme.brightness == Brightness.light ? TcmColors.voteIconColor : colorScheme.onSecondary;
    return Row(
      children: [
        if(onVoteCast!=null)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: VoteIcon(
              onPressed: () => onVoteCast!(isUpvote: (isUpvoted == null || isUpvoted == false) ? true : null),
              color: (isUpvoted!=null && isUpvoted!) ? TcmColors.upvotedIconColor : voteIconColor,
            ),
          ),
        Tooltip(
          message: '$voteCount vote${voteCount.abs()==1 ? '':'s'}\n$voteValueSum point${voteValueSum.abs()==1 ? '':'s'}',
          // textStyle: TextStyle(
          //   color: colorScheme.onSecondary,
          // ),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(10),
          //   color: colorScheme.secondary.withOpacity(0.9)
          // ),
          triggerMode: TooltipTriggerMode.tap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: voteIconColor,
                borderRadius: BorderRadius.circular(50)
            ),
            child: FittedBox(child: Text(voteValueSum.toText, style: TextStyle(color: Colors.white),)),
          ),
        ),
        if(onVoteCast!=null)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: VoteIcon(
              onPressed: () => onVoteCast!(isUpvote: (isUpvoted == null || isUpvoted == true) ? false : null),
              isDown: true,
              // color: Color.fromRGBO(255, 78, 78, 1),
              color: (isUpvoted!=null && !isUpvoted!) ? TcmColors.downvotedIconColor : voteIconColor,
            ),
          ),
      ],
    );
  }
}
