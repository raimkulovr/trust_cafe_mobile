import 'package:equatable/equatable.dart';

final class Reaction extends Equatable {
  static const String sourceTypeAsset = 'asset';

  static Map<String, Reaction> knownReactions = const {
    'ghost': Reaction._('ghost', 1, source: sourceTypeAsset),
    'jack_o_lantern': Reaction._('jack_o_lantern', 2, source: sourceTypeAsset),
    'thumbs_up': Reaction._('thumbs_up', 3, source: sourceTypeAsset),
    'partying_face': Reaction._('partying_face', 4, source: sourceTypeAsset),
    'rofl': Reaction._('rofl', 5, source: sourceTypeAsset),
    'fingers_crossed': Reaction._('fingers_crossed', 6, source: sourceTypeAsset),
    'sunglasses': Reaction._('sunglasses', 7, source: sourceTypeAsset),
    'crying_face': Reaction._('crying_face', 8, source: sourceTypeAsset),

    'blue_heart': Reaction._('blue_heart', 9, source: sourceTypeAsset),
    'eyes': Reaction._('eyes', 10, source: sourceTypeAsset),
    'thinking_face': Reaction._('thinking_face', 11, source: sourceTypeAsset),
    'trust_branch': Reaction._('trust_branch', 12, source: sourceTypeAsset),

    'cold_sweat': Reaction._('cold_sweat', 0, source: sourceTypeAsset),
    'astonished': Reaction._('astonished', 0, source: sourceTypeAsset),
    'relieved': Reaction._('relieved', 0, source: sourceTypeAsset),
    'shrug': Reaction._('shrug', 0, source: sourceTypeAsset),
    'xmas_tree': Reaction._('xmas_tree', 0, source: sourceTypeAsset),
    'thumbs_down': Reaction._('thumbs_down', 0, source: sourceTypeAsset),
    'rage': Reaction._('rage', 0, source: sourceTypeAsset),
  };

  const Reaction._(this.name, this.priority, {required this.source});
  const Reaction.unknown() : name = 'unknown', priority = 0,  source = sourceTypeAsset;

  /// The name of the reaction from the backend.
  /// Also used to map the correct image asset if [source] == [sourceTypeAsset].
  final String name;

  /// Since [knownReactions] uses a HashMap, which is unordered,
  /// we use this parameter to fine-tune the emoji positions when
  /// displaying the list of reactions to users.
  ///
  /// When this value is lower than 1, it is not displayed in the "Reaction Options" tooltip.
  final int priority;

  /// Treated as URL if not equal to [sourceTypeAsset]
  final String source;

  bool get isNotUnknown => this != const Reaction.unknown();

  @override
  List<Object?> get props => [name, priority, source];
}

class Reactions extends Equatable {
  final Map<Reaction, int> values;

  Reactions({
    this.values = const {},
  });

  const Reactions.empty() : values = const {};

  bool get isEmpty => this == const Reactions.empty();

  Reactions modifyBy(String newReaction, {bool add = true}){
    final modificationValue = add ? 1 : -1;

    final reaction = Reaction.knownReactions[newReaction];
    if(reaction==null) return this;

    final newValues = {...values};
    newValues.update(reaction, (value) => value+modificationValue, ifAbsent: () => modificationValue);

    return copyWith(values: newValues);
  }

  Reactions copyWith({
    Map<Reaction, int>? values
  }) => Reactions(
    values: values ?? this.values,
  );

  @override
  List<Object?> get props => [values];

}