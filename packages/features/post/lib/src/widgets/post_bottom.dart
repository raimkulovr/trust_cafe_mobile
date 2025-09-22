import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../post_cubit.dart';
import 'widgets.dart';

class PostBottom extends StatelessWidget {
  const PostBottom(this.post, {
    this.horizontalPadding = 8,
    super.key,
  });

  final Post post;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final commentCount = post.statistics.commentCount;
    final appUser = PostCallbackProvider.of(context).getAppUser();

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 30,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Padding(
          padding: EdgeInsets.only(right: horizontalPadding, left: 4),
          child: BlocBuilder<PostCubit, PostState>(
              buildWhen: (p, c) =>
                p.voteValueSum!=c.voteValueSum ||
                p.voteCount!=c.voteCount ||
                p.isUpvoted!=c.isUpvoted,
              builder: (context, state) {
                return Row(
                  children: [
                    if(!post.isArchived) (appUser.isNotGuest || appUser.isGuest && commentCount!=0)
                        ? TcmTextButton(
                            onTap: (){
                              PostCallbackProvider.of(context).showComments(post, shouldScrollToSlug: false);
                            },
                            text: commentCount==0
                                ? 'Add a comment…'
                                : 'View ${commentCount.toText} comment${commentCount.abs()>1 ? 's':''}',
                          )
                        : const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: FittedBox(child:
                              Text('no comments',
                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),)),
                          ),
                    const Spacer(),
                    appUser.isNotGuest
                        ? Row(
                            children: [
                              if(!post.isArchived) ReactionsTooltipWidget(context.read<PostCubit>().castReaction),
                              VoteCastWidget(
                                voteValueSum: state.voteValueSum,
                                voteCount: state.voteCount,
                                isUpvoted: state.isUpvoted,
                                onVoteCast: post.isArchived
                                    ? null
                                    : ({isUpvote}) => context.read<PostCubit>().castVote(isUpvote: isUpvote,),
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
