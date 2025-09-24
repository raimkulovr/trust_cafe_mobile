// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spider_oembed_data_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpiderOembedDataResponseModel _$SpiderOembedDataResponseModelFromJson(
        Map<String, dynamic> json) =>
    SpiderOembedDataResponseModel(
      type: json['type'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      providerName: json['provider_name'] as String,
      html: json['html'] as String,
      authorName: json['author_name'] as String?,
      authorUrl: json['author_url'] as String?,
    );
