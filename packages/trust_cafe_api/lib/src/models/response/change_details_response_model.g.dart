// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeDetailsResponseModel _$ChangeDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    ChangeDetailsResponseModel(
      changeLabel: json['changeLabel'] as String?,
      slug: json['slug'] as String,
      uri: json['uri'] as String,
      createdAt: (json['createdAt'] as num).toInt(),
      changeTextData: ChangeTextDataResponseModel.fromJson(
          json['changeTextData'] as Map<String, dynamic>),
      author:
          _$JsonConverterFromJson<Map<String, dynamic>, AuthorResponseModel>(
              json['data'], const ChangeDataUserConverter().fromJson),
      createdByUser: json['createdByUser'] == null
          ? null
          : AuthorResponseModel.fromJson(
              json['createdByUser'] as Map<String, dynamic>),
      action: json['action'] as String?,
      changeText: json['changeText'] as String?,
    );

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

ChangeTextDataResponseModel _$ChangeTextDataResponseModelFromJson(
        Map<String, dynamic> json) =>
    ChangeTextDataResponseModel(
      type: json['type'] as String,
      entity: json['entity'] as String,
    );
