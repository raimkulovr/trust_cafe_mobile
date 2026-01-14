import 'package:json_annotation/json_annotation.dart';

class StringDoubleNullConverter extends JsonConverter<String?, dynamic> {
  const StringDoubleNullConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is String) return json;
    if (json is num) return json.toString();
    return null;
  }

  @Deprecated(
      'Technically not intended to be used since this converter is only used for deserialization.')
  @override
  Map<String?, dynamic> toJson(String? object) {
    throw UnimplementedError();
  }
}
