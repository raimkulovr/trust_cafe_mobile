import 'package:flutter/material.dart';

import 'reaction_image.dart';
import '../component_library.dart';
import 'package:domain_models/domain_models.dart';

class ReactionsTooltipWidget extends StatelessWidget {
  const ReactionsTooltipWidget(this.onReaction, {super.key});

  final void Function(String) onReaction;

  List<Widget> _buildReactionOptions(){
    final allowedReactions = Reaction.knownReactions.values.where((e) => e.priority >= 1,).toList();
    allowedReactions.sort((a, b) => a.priority.compareTo(b.priority),);

    final List<Widget> options = [];
    List<Widget> row = [];

    for(int i = 0; i < allowedReactions.length; i++){
      row.add(_ReactionWidget(allowedReactions.elementAt(i), onReaction));

      if((i+1)%4==0){
        options.add(Row(spacing: 6, children: row,));
        row = [];
      }
    }

    if(row.isNotEmpty){
      options.add(Row(spacing: 6, children: row,));
    }

    return options;
  }

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
            spacing: 3,
            children: [
              const Text('Reaction options', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
              Container(height: 1, width: 152, color: colorScheme.primary, margin: const EdgeInsets.symmetric(vertical: 3),),
              ..._buildReactionOptions(),
            ]
        ))))]);
  }
}

class _ReactionWidget extends StatelessWidget {
  const _ReactionWidget(this.reaction, this.onTap, {super.key});

  final Reaction reaction;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(reaction.name);
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: ReactionImage(reaction),
      ),
    );
  }
}


