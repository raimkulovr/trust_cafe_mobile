import 'package:json_annotation/json_annotation.dart';
import 'package:trust_cafe_api/src/models/response/last_evaluated_key_response_model.dart';
import 'subwiki_details_response_model.dart';

part 'subwiki_page_response_model.g.dart';

@JsonSerializable(createToJson: false)
class SubwikiPageResponseModel{
  const SubwikiPageResponseModel({
    required this.itemList,
    this.lastEvaluatedKey,
  });

  @JsonKey(name: 'items')
  final List<SubwikiDetailsResponseModel> itemList;

  @JsonKey(name: 'lastEvaluatedKey')
  final LastEvaluatedKeyResponseModel? lastEvaluatedKey;

  static const fromJson = _$SubwikiPageResponseModelFromJson;
}
