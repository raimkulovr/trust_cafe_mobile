import 'package:json_annotation/json_annotation.dart';

class TrustLevelInfoConverter
    extends JsonConverter<String, Map<String, dynamic>> {
  const TrustLevelInfoConverter();

  @override
  String fromJson(Map<String, dynamic> json) => json['aka'] as String;

  @Deprecated('Technically not intended to be used since this converter is only used for deserialization.')
  @override
  Map<String, dynamic> toJson(String object) {
    throw UnimplementedError();
  }
}