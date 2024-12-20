import 'package:component_library/src/utility/utility_popup_menu_widget.dart';
import 'package:flutter/material.dart';

import '../component_library.dart';

class ReactionsTooltipWidget extends StatelessWidget {
  const ReactionsTooltipWidget(this.onReaction, {super.key});

  final void Function(String) onReaction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final voteIconColor = colorScheme.brightness == Brightness.light ? TcmColors.voteIconColor : Colors.white;
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.add_reaction, size: 19, color: voteIconColor,),
      tooltip: 'Show reaction options',
      itemBuilder: (context) => [PopupMenuWidget(height: 0, child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Text('Reaction options', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
            Container(height: 1, width: 152, color: colorScheme.primary, margin: const EdgeInsets.symmetric(vertical: 3),),
            Row(children: [
              _ReactionWidget('partying_face', onReaction),
              const SizedBox(width: 6,),
              _ReactionWidget('rofl', onReaction),
              const SizedBox(width: 6,),
              _ReactionWidget('rage', onReaction),
              const SizedBox(width: 6,),
              _ReactionWidget('cold_sweat', onReaction),
            ],),
            const SizedBox(height: 3,),
            Row(children: [
              _ReactionWidget('fingers_crossed', onReaction),
              const SizedBox(width: 6,),
              _ReactionWidget('sunglasses', onReaction),
              const SizedBox(width: 6,),
              _ReactionWidget('relieved', onReaction),
              const SizedBox(width: 6,),
              _ReactionWidget('blue_heart', onReaction),
            ],),
            const SizedBox(height: 3,),
            Row(children: [
              _ReactionWidget('astonished', onReaction),
              const SizedBox(width: 6,),
              _ReactionWidget('eyes', onReaction),
              const SizedBox(width: 6,),
              _ReactionWidget('shrug', onReaction),
              const SizedBox(width: 6,),
              _ReactionWidget('trust_branch', onReaction),
            ],),

          ],),
        ),
      ),)],);
  }
}

class _ReactionWidget extends StatelessWidget {
  const _ReactionWidget(this.reaction, this.onTap, {super.key});

  final String reaction;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {onTap(reaction); Navigator.of(context).pop();},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Image.asset('assets/icons/reactions/$reaction.png',
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}


