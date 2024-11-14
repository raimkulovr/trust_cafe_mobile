import 'package:json_annotation/json_annotation.dart';

part 'reactions_response_model.g.dart';

@JsonSerializable(createToJson: false)
class ReactionsResponseModel{
  const ReactionsResponseModel({
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

  @JsonKey(name: 'blue_heart')
  final int? blueHeart;
  @JsonKey(name: 'cold_sweat')
  final int? coldSweat;
  @JsonKey(name: 'fingers_crossed')
  final int? fingersCrossed;
  @JsonKey(name: 'partying_face')
  final int? partyingFace;
  final int? rage;
  final int? relieved;
  final int? rofl;
  final int? sunglasses;
  @JsonKey(name: 'trust_branch')
  final int? trustBranch;
  final int? eyes;
  final int? astonished;
  final int? shrug;

  static const fromJson = _$ReactionsResponseModelFromJson;

}