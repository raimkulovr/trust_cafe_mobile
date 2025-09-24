// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_page_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentPageResponseModel _$CommentPageResponseModelFromJson(
        Map<String, dynamic> json) =>
    CommentPageResponseModel(
      commentList: (json['Items'] as List<dynamic>)
          .map((e) => CommentResponseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastEvaluatedKey: json['LastEvaluatedKey'] == null
          ? null
          : LastEvaluatedKeyResponseModel.fromJson(
              json['LastEvaluatedKey'] as Map<String, dynamic>),
    );
