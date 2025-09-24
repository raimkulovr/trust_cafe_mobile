// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_page_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePageResponseModel _$ChangePageResponseModelFromJson(
        Map<String, dynamic> json) =>
    ChangePageResponseModel(
      changeList: (json['recentChanges'] as List<dynamic>)
          .map((e) =>
              ChangeDetailsResponseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastEvaluatedKey: json['LastEvaluatedKey'] == null
          ? null
          : LastEvaluatedKeyResponseModel.fromJson(
              json['LastEvaluatedKey'] as Map<String, dynamic>),
    );
