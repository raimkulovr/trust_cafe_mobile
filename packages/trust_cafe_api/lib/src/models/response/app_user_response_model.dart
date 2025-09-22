import 'package:json_annotation/json_annotation.dart';
import 'package:trust_cafe_api/src/models/response/trust_level_info_converter.dart';

part 'app_user_response_model.g.dart';

@JsonSerializable(createToJson: false)
class AppUserResponseModel {
  const AppUserResponseModel({
    required this.userId,
    required this.slug,
    required this.fname,
    required this.lname,
    required this.userLanguage,
    required this.groups,
    required this.trustLevelInfo,
    required this.voteValue,
  });

  @JsonKey(name: 'userID')
  final String userId;
  final String slug;
  final String fname;
  final String lname;
  @JsonKey(name: 'userlanguage')
  final String userLanguage;
  final List<String> groups;
  final TrustLevelInfoResponseModel trustLevelInfo;
  @JsonKey(name: 'votevalue')
  final int voteValue;

  const AppUserResponseModel.guest() :
      userId = 'guest',
      slug = '',
      fname = '',
      lname = '',
      userLanguage = '',
      groups = const [],
      trustLevelInfo = const TrustLevelInfoResponseModel(aka: '', trustLevelInt: 0),
      voteValue = 0;

  static const fromJson = _$AppUserResponseModelFromJson;

}

@JsonSerializable(createToJson: false)
class TrustLevelInfoResponseModel {
  const TrustLevelInfoResponseModel({
    required this.aka,
    required this.trustLevelInt,
  });
  final String aka;
  final int trustLevelInt;

  static const fromJson = _$TrustLevelInfoResponseModelFromJson;
}

@JsonSerializable(createToJson: false)
class AppUserVoteResponseModel {
  const AppUserVoteResponseModel({
    required this.parent,
    required this.vote,
  });

  final AppUserVoteParentResponseModel parent;
  final String vote;

  static const fromJson =  _$AppUserVoteResponseModelFromJson;

}

@JsonSerializable(createToJson: false)
class AppUserVoteParentResponseModel {
  const AppUserVoteParentResponseModel({
    required this.sk,
    required this.pk,
  });

  final String sk;
  final String pk;

  static const fromJson =  _$AppUserVoteParentResponseModelFromJson;

}