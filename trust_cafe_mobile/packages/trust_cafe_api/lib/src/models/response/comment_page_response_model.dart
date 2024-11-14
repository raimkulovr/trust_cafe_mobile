import 'package:json_annotation/json_annotation.dart';
import 'comment_response_model.dart';
import 'last_evaluated_key_response_model.dart';

part 'comment_page_response_model.g.dart';

@JsonSerializable(createToJson: false)
class CommentPageResponseModel{
  const CommentPageResponseModel({
    required this.commentList,
    this.lastEvaluatedKey,
  });

  @JsonKey(name: 'Items')
  final List<CommentResponseModel> commentList;

  @JsonKey(name: 'LastEvaluatedKey')
  final LastEvaluatedKeyResponseModel? lastEvaluatedKey;

  static const fromJson = _$CommentPageResponseModelFromJson;
}