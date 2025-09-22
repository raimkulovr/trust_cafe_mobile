import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:domain_models/domain_models.dart';

class ReactionImage extends StatelessWidget {
  const ReactionImage(this.reaction, {this.enforceSize = true, super.key});

  final Reaction reaction;
  final bool enforceSize;

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProvider = reaction.source == Reaction.sourceTypeAsset
        ? AssetImage('assets/icons/reactions/${reaction.name}.png')
        : CachedNetworkImageProvider(reaction.source);

    return Image(image: imageProvider,
      height: enforceSize ? 30 : null,
      width: enforceSize ? 30 : null,
      errorBuilder: (_, __, ___) => const FittedBox(child: Icon(Icons.error)),
    );
  }
}
