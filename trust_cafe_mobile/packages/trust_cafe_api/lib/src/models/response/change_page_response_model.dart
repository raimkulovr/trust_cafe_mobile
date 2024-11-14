import 'package:json_annotation/json_annotation.dart';
import 'change_details_response_model.dart';
import 'last_evaluated_key_response_model.dart';

part 'change_page_response_model.g.dart';

@JsonSerializable(createToJson: false)
class ChangePageResponseModel{
  const ChangePageResponseModel({
    required this.changeList,
    this.lastEvaluatedKey,
  });

  @JsonKey(name: 'Items')
  final List<ChangeDetailsResponseModel> changeList;

  @JsonKey(name: 'LastEvaluatedKey')
  final LastEvaluatedKeyResponseModel? lastEvaluatedKey;

  static const fromJson = _$ChangePageResponseModelFromJson;
}