import 'package:domain_models/domain_models.dart';

extension ReactionMapToDM on Map<String, int> {
  Reactions toDomainModel() {
    final Map<Reaction, int> reactions = {};

    forEach((key, value) {
      final reaction = Reaction.knownReactions[key] ?? const Reaction.unknown();
      reactions[reaction] = value;
    },);

    return Reactions(values: reactions);
  }
}