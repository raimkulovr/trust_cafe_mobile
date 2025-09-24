// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subwiki_page_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubwikiPageResponseModel _$SubwikiPageResponseModelFromJson(
        Map<String, dynamic> json) =>
    SubwikiPageResponseModel(
      itemList: (json['items'] as List<dynamic>)
          .map((e) =>
              SubwikiDetailsResponseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastEvaluatedKey: json['lastEvaluatedKey'] == null
          ? null
          : LastEvaluatedKeyResponseModel.fromJson(
              json['lastEvaluatedKey'] as Map<String, dynamic>),
    );
