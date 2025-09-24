// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_page_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostPageResponseModel _$PostPageResponseModelFromJson(
        Map<String, dynamic> json) =>
    PostPageResponseModel(
      postList: (json['Items'] as List<dynamic>)
          .map((e) =>
              PostDetailsResponseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastEvaluatedKey: json['LastEvaluatedKey'] == null
          ? null
          : LastEvaluatedKeyResponseModel.fromJson(
              json['LastEvaluatedKey'] as Map<String, dynamic>),
    );
