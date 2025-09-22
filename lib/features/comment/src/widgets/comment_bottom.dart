
import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../comment_cubit.dart';
import 'comment_callback_provider.dart';

class CommentBottom extends StatelessWidget {
  const CommentBottom(this.comment, {
    this.horizontalPadding = 8,
    super.key,
  });

  final Comment comment;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final appUser = CommentCallbackProvider.of(context).getAppUser();
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 30,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Padding(
          padding: EdgeInsets.only(right: horizontalPadding, left: 4),
          child: BlocBuilder<CommentCubit, CommentState>(
              buildWhen: (p, c) =>
                  p.voteValueSum!=c.voteValueSum ||
                  p.voteCount!=c.voteCount ||
                  p.isUpvoted!=c.isUpvoted,
              builder: (context, state) {
                return Row(
                  children: [
                    if(appUser.isNotGuest)
                      FittedBox(
                        child: TcmTextButton(
                          onTap: ()=> CommentCallbackProvider.of(context).onCommentReplied(slug: comment.slug, sk: comment.sk, pk: comment.pk, fullName: comment.data.createdByUser.fullName),
                          icon: Icons.reply,
                          text: 'reply',
                        ),
                      ),
                    const Spacer(),
                    appUser.isNotGuest
                      ? Row(
                          children: [
                            ReactionsTooltipWidget(context.read<CommentCubit>().castReaction),
                            VoteCastWidget(
                              voteValueSum: state.voteValueSum,
                              voteCount: state.voteCount,
                              onVoteCast: ({isUpvote}) => context.read<CommentCubit>().castVote(isUpvote: isUpvote,),
                              isUpvoted: state.isUpvoted,
                            ),
                          ],
                        )
                      : VoteCastWidget(
                          voteValueSum: state.voteValueSum,
                          voteCount: state.voteCount,
                          onVoteCast: null,
                          isUpvoted: null,
                        )
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}