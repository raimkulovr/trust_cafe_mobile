// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spider_fetch_data_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpiderFetchDataResponseModel _$SpiderFetchDataResponseModelFromJson(
        Map<String, dynamic> json) =>
    SpiderFetchDataResponseModel(
      title: json['title'] as String,
      screenshot: json['screenshot'] as String,
      cachedImage: _$JsonConverterFromJson<Map<String, dynamic>, String>(
          json['cached_images'], const CachedImageConverter().fromJson),
      description: json['description'] as String?,
      ogDescription: json['og:description'] as String?,
    );

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
