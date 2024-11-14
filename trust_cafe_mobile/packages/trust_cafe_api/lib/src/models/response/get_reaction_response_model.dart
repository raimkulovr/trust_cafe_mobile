import 'package:json_annotation/json_annotation.dart';

part 'get_reaction_response_model.g.dart';

@JsonSerializable(createToJson: false)
class GetReactionResponseModel {
  const GetReactionResponseModel({
    this.reaction,
  });

  final String? reaction;

  static const fromJson = _$GetReactionResponseModelFromJson;
}