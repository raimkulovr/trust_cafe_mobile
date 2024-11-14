import 'package:json_annotation/json_annotation.dart';

part 'spider_oembed_data_response_model.g.dart';

@JsonSerializable(createToJson: false)
class SpiderOembedDataResponseModel{
  const SpiderOembedDataResponseModel({
    required this.type,
    required this.title,
    required this.thumbnailUrl,
    required this.providerName,
    required this.html,
    this.authorName,
    this.authorUrl,
  });

  @JsonKey(name: 'author_name')
  final String? authorName;
  @JsonKey(name: 'author_url')
  final String? authorUrl;
  final String type;
  final String title;
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @JsonKey(name: 'provider_name')
  final String providerName;
  final String html;

  static const fromJson = _$SpiderOembedDataResponseModelFromJson;

}
