import 'package:equatable/equatable.dart';

class Reactions extends Equatable{
  const Reactions({
    required this.blueHeart,
    required this.coldSweat,
    required this.fingersCrossed,
    required this.partyingFace,
    required this.rage,
    required this.relieved,
    required this.rofl,
    required this.sunglasses,
    required this.trustBranch,
    required this.eyes,
    required this.astonished,
    required this.shrug,
  });

  const Reactions.empty() :
      this.blueHeart = 0,
      this.coldSweat = 0,
      this.fingersCrossed = 0,
      this.partyingFace = 0,
      this.rage = 0,
      this.relieved = 0,
      this.rofl = 0,
      this.sunglasses = 0,
      this.trustBranch = 0,
      this.eyes = 0,
      this.astonished = 0,
      this.shrug = 0;

  final int blueHeart;
  final int coldSweat;
  final int fingersCrossed;
  final int partyingFace;
  final int rage;
  final int relieved;
  final int rofl;
  final int sunglasses;
  final int trustBranch;
  final int eyes;
  final int astonished;
  final int shrug;

  Map<String, int> get all => {
    'blue_heart': blueHeart,
    'cold_sweat': coldSweat,
    'fingers_crossed': fingersCrossed,
    'partying_face': partyingFace,
    'rage': rage,
    'relieved': relieved,
    'rofl': rofl,
    'sunglasses': sunglasses,
    'trust_branch': trustBranch,
    'eyes': eyes,
    'astonished': astonished,
    'shrug': shrug,
};

  bool get isEmpty => this == const Reactions.empty();

  @override
  List<Object?> get props => [
    blueHeart,
    coldSweat,
    fingersCrossed,
    partyingFace,
    rage,
    relieved,
    rofl,
    sunglasses,
    trustBranch,
    eyes,
    astonished,
    shrug,
  ];

  Reactions copyWith({
    int? blueHeart,
    int? coldSweat,
    int? fingersCrossed,
    int? partyingFace,
    int? rage,
    int? relieved,
    int? rofl,
    int? sunglasses,
    int? trustBranch,
    int? eyes,
    int? astonished,
    int? shrug,
  }) {
    return Reactions(
      blueHeart: blueHeart ?? this.blueHeart,
      coldSweat: coldSweat ?? this.coldSweat,
      fingersCrossed: fingersCrossed ?? this.fingersCrossed,
      partyingFace: partyingFace ?? this.partyingFace,
      rage: rage ?? this.rage,
      relieved: relieved ?? this.relieved,
      rofl: rofl ?? this.rofl,
      sunglasses: sunglasses ?? this.sunglasses,
      trustBranch: trustBranch ?? this.trustBranch,
      eyes: eyes ?? this.eyes,
      astonished: astonished ?? this.astonished,
      shrug: shrug ?? this.shrug,
    );
  }

  Reactions modifyBy(String reaction, {bool add = true}){
    final modificationValue = add ? 1 : -1;
    return switch(reaction){
      'blue_heart' => copyWith(blueHeart: blueHeart+modificationValue),
      'cold_sweat' => copyWith(coldSweat: coldSweat+modificationValue),
      'fingers_crossed' => copyWith(fingersCrossed: fingersCrossed+modificationValue),
      'partying_face' => copyWith(partyingFace: partyingFace+modificationValue),
      'rage' => copyWith(rage: rage+modificationValue),
      'relieved' => copyWith(relieved: relieved+modificationValue),
      'rofl' => copyWith(rofl: rofl+modificationValue),
      'sunglasses' => copyWith(sunglasses: sunglasses+modificationValue),
      'trust_branch' => copyWith(trustBranch: trustBranch+modificationValue),
      'eyes' => copyWith(eyes: eyes+modificationValue),
      'astonished' => copyWith(astonished: astonished+modificationValue),
      'shrug' => copyWith(shrug: shrug+modificationValue),
      _ => this,
    };
  }

}