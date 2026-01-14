import 'package:json_annotation/json_annotation.dart';
import 'helper/trust_level_info_converter.dart';
import 'helper/string_double_null_converter.dart';

part 'author_response_model.g.dart';

@JsonSerializable(createToJson: false)
class AuthorResponseModel{
  const AuthorResponseModel({
    required this.fname,
    required this.userLanguage,
    required this.lname,
    required this.userId,
    required this.slug,
    this.trustLevel = '',
    this.trustName,
    this.membershipType,
  });

  final String fname;
  @JsonKey(name: 'userlanguage')
  final String? userLanguage;
  final String lname;
  @JsonKey(name: 'userID')
  final String userId;
  final String slug;
  @StringDoubleNullConverter()
  final String? trustLevel;
  @TrustLevelInfoConverter()
  @JsonKey(name: 'trustLevelInfo')
  final String? trustName;

  final String? membershipType;

  static const fromJson = _$AuthorResponseModelFromJson;

}
