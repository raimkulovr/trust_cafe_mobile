import 'package:hive/hive.dart';
part 'reactions_cache_model.g.dart';

@HiveType(typeId: 18)
class ReactionsCacheModel {
  ReactionsCacheModel({
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

  @HiveField(0)
  final int? blueHeart;
  @HiveField(1)
  final int? coldSweat;
  @HiveField(2)
  final int? fingersCrossed;
  @HiveField(3)
  final int? partyingFace;
  @HiveField(4)
  final int? rage;
  @HiveField(5)
  final int? relieved;
  @HiveField(6)
  final int? rofl;
  @HiveField(7)
  final int? sunglasses;
  @HiveField(8)
  final int? trustBranch;
  @HiveField(9)
  final int? eyes;
  @HiveField(10)
  final int? astonished;
  @HiveField(11)
  final int? shrug;

}