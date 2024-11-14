import 'package:component_library/src/number_to_text_extension.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

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
      ...[...reactions.all.keys.where((e) => reactions.all[e]!>0)]
        ..sort((a, b) => reactions.all[b]!.compareTo(reactions.all[a]!),),
      'whitespace',
    ];
    // print('$selectedReaction|||$reactionList');
    return reactionList.length>=3 ? Container(
      height: 24,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final reaction = reactionList[index];
            return reaction == 'whitespace' ? const SizedBox() : Container(
              decoration: BoxDecoration(
                color: colorScheme.outline.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    width: 1,
                    color: selectedReaction == reaction ? colorScheme.outline.withOpacity(colorScheme.brightness==Brightness.dark ? 1 : 0.8) : Colors.transparent),
              ),
              child: InkWell(
                onTap: onReaction!=null ? ()=> onReaction!(reaction) : null,
                borderRadius: BorderRadius.circular(10),
                // splashColor: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Image.asset('assets/icons/reactions/$reaction.png'),
                      ),
                      const SizedBox(width: 4,),
                      // Text(reactions.all[reaction].toString())
                      FittedBox(child: Text(reactions.all[reaction]!.toText))
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 8,),
          itemCount: reactionList.length),
    ) : const SizedBox();
  }
}

