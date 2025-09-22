import 'package:json_annotation/json_annotation.dart';

part 'spider_fetch_data_response_model.g.dart';

@JsonSerializable(createToJson: false)
class SpiderFetchDataResponseModel{
  const SpiderFetchDataResponseModel({
    required this.title,
    required this.screenshot,
    this.cachedImage,
    this.description,
    this.ogDescription,
  });

  final String title;
  final String screenshot;

  @CachedImageConverter()
  @JsonKey(name: 'cached_images')
  final String? cachedImage;
  final String? description;
  @JsonKey(name: 'og:description')
  final String? ogDescription;

  static const fromJson = _$SpiderFetchDataResponseModelFromJson;

}

class CachedImageConverter
    extends JsonConverter<String, Map<String, dynamic>> {
  const CachedImageConverter();

  @override
  String fromJson(Map<String, dynamic> json) => (json['og:image'] ?? json['twitter:image'] ?? '') as String;

  @Deprecated('Technically not intended to be used since this converter is only used for deserialization.')
  @override
  Map<String, dynamic> toJson(String object) {
    throw UnimplementedError();
  }
}
