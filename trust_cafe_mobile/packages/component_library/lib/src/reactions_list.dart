import 'package:component_library/src/utility/number_to_text_extension.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

import 'reaction_image.dart';

class ReactionsListWidget extends StatelessWidget {
  const ReactionsListWidget(this.reactions, {this.selectedReaction, this.onReaction, super.key});

  final Reactions reactions;
  final String? selectedReaction;

  final void Function(String)? onReaction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final reactionList = [
      'whitespace',
      ...[...reactions.values.entries.where((e) => e.value>0 && e.key.isNotUnknown,)]
        ..sort((a, b) => b.value.compareTo(a.value),),
      'whitespace',
    ];

    if(reactionList.length<3) return  const SizedBox();

    return Container(
      height: 24,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final reaction = reactionList[index];

            if(reaction == 'whitespace') return const SizedBox();

            reaction as MapEntry<Reaction, int>;

            return Container(
              decoration: BoxDecoration(
                color: colorScheme.outline.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    width: 1,
                    color: selectedReaction == reaction.key.name ? colorScheme.outline.withOpacity(colorScheme.brightness==Brightness.dark ? 1 : 0.8) : Colors.transparent),
              ),
              child: InkWell(
                onTap: onReaction!=null ? ()=> onReaction!(reaction.key.name) : null,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: ReactionImage(reaction.key, enforceSize: false,),
                      ),
                      const SizedBox(width: 4,),
                      FittedBox(child: Text(reaction.value.toText))
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 8,),
          itemCount: reactionList.length),
    );
  }
}

