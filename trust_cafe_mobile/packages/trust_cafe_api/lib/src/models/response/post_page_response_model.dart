import 'package:json_annotation/json_annotation.dart';
import 'package:trust_cafe_api/src/models/response/last_evaluated_key_response_model.dart';
import 'package:trust_cafe_api/src/models/response/post_details_response_model.dart';

part 'post_page_response_model.g.dart';

@JsonSerializable(createToJson: false)
class PostPageResponseModel{
  const PostPageResponseModel({
    required this.postList,
    this.lastEvaluatedKey,
  });

  @JsonKey(name: 'Items')
  final List<PostDetailsResponseModel> postList;

  @JsonKey(name: 'LastEvaluatedKey')
  final LastEvaluatedKeyResponseModel? lastEvaluatedKey;

  static const fromJson = _$PostPageResponseModelFromJson;
}
