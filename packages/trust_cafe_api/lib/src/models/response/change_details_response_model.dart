import 'package:json_annotation/json_annotation.dart';
import 'package:trust_cafe_api/src/models/models.dart';

part 'change_details_response_model.g.dart';

@JsonSerializable(createToJson: false)
class ChangeDetailsResponseModel{
  const ChangeDetailsResponseModel({
    required this.changeLabel,
    required this.action,
    required this.slug,
    required this.uri,
    required this.createdAt,
    required this.changeText,
    required this.author,
    required this.changeTextData,
  });

  final String? changeLabel;
  final String action;
  final String slug;
  final String uri;
  final int createdAt;
  final String changeText;
  @JsonKey(name: 'data')
  @ChangeDataUserConverter()
  final AuthorResponseModel author;
  final ChangeTextDataResponseModel changeTextData;

  static const fromJson = _$ChangeDetailsResponseModelFromJson;

}

@JsonSerializable(createToJson: false)
class ChangeTextDataResponseModel {
  const ChangeTextDataResponseModel({
    required this.type,
    required this.entity,
  });

  final String type;
  final String entity;

  static const fromJson = _$ChangeTextDataResponseModelFromJson;
}

class ChangeDataUserConverter
    extends JsonConverter<AuthorResponseModel, Map<String, dynamic>> {
  const ChangeDataUserConverter();

  @override
  AuthorResponseModel fromJson(Map<String, dynamic> json) {
    return AuthorResponseModel.fromJson(json['user'] as Map<String, dynamic>);
  }

  @Deprecated('Technically not intended to be used since this converter is only used for deserialization.')
  @override
  Map<String, dynamic> toJson(AuthorResponseModel? object) {
    throw UnimplementedError();
  }
}