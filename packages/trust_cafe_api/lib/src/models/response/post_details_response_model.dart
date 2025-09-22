import 'package:json_annotation/json_annotation.dart';
import 'package:trust_cafe_api/src/models/response/author_response_model.dart';
import 'package:trust_cafe_api/src/models/response/reactions_response_model.dart';

part 'post_details_response_model.g.dart';

@JsonSerializable(createToJson: false)
class PostDetailsResponseModel {
  const PostDetailsResponseModel(
      {
        required this.collaborative,
        required this.statistics,
        required this.createdAt,
        required this.postId,
        required this.postText,
        required this.data,
        required this.updatedAt,
        required this.subReply,
        required this.sk,
        required this.cardUrl,
        required this.pk,
        required this.authors,
        this.blurLabel,
        this.archivedBy,
      });
  final bool? collaborative;
  final PostStatisticsResponseModel? statistics;
  final int createdAt;
  @JsonKey(name: 'postID')
  final String postId;
  final String postText;
  final PostDataResponseModel data;
  final int updatedAt;
  final int? subReply;
  final String sk;
  final String pk;
  final String? cardUrl;
  final List<AuthorResponseModel>? authors;
  final String? blurLabel;
  @ArchivedByConverter()
  final String? archivedBy;

  static const fromJson = _$PostDetailsResponseModelFromJson;

}

@JsonSerializable(createToJson: false)
class PostDataResponseModel {
  const PostDataResponseModel({
    required this.createdByUser,
    required this.subwiki,
    required this.maintrunk,
    required this.userprofile,
  });
  final AuthorResponseModel createdByUser;
  final SubwikiPostOriginResponseModel? subwiki;
  final MainTrunkPostOriginResponseModel? maintrunk;
  final UserProfilePostOriginResponseModel? userprofile;

  static const fromJson = _$PostDataResponseModelFromJson;
}

abstract class PostOriginResponseModel{
  const PostOriginResponseModel({
    this.slug,
    this.sk,
    this.pk,
  });
  final String? slug;
  final String? sk;
  final String? pk;
}

@JsonSerializable(createToJson: false)
class SubwikiPostOriginResponseModel extends PostOriginResponseModel{
  SubwikiPostOriginResponseModel(
      {
        super.slug,
        super.sk,
        super.pk,
        this.label,
      });
  final String? label;

  static const fromJson =_$SubwikiPostOriginResponseModelFromJson;
}

@JsonSerializable(createToJson: false)
class MainTrunkPostOriginResponseModel extends PostOriginResponseModel{
  MainTrunkPostOriginResponseModel(
      {
        super.slug,
        super.sk,
        super.pk,
      });

  static const fromJson =_$MainTrunkPostOriginResponseModelFromJson;
}

@JsonSerializable(createToJson: false)
class UserProfilePostOriginResponseModel extends PostOriginResponseModel{
  UserProfilePostOriginResponseModel(
      {
        super.slug,
        super.sk,
        super.pk,
        this.fname,
        this.lname,
        this.userId,
      });
  final String? fname;
  final String? lname;
  @JsonKey(name: 'userID')
  final String? userId;

  static const fromJson =_$UserProfilePostOriginResponseModelFromJson;
}

@JsonSerializable(createToJson: false)
class PostStatisticsResponseModel{
  const PostStatisticsResponseModel(
      {
        required this.authorCount,
        required this.commentCount,
        required this.topLevelCommentCount,
        required this.revisionCount,
        required this.voteCount,
        required this.voteValueSum,
        this.reactions,
      });
  final int? authorCount;
  final int? commentCount;
  @JsonKey(name: 'commentCountTopLevel')
  final int? topLevelCommentCount;
  final int? revisionCount;
  final int? voteCount;
  final int? voteValueSum;
  final ReactionsResponseModel? reactions;

  static const fromJson = _$PostStatisticsResponseModelFromJson;

}

class ArchivedByConverter
    extends JsonConverter<String?, dynamic> {
  const ArchivedByConverter();

  @override
  String? fromJson(dynamic json) {
    if(json is String?){
      return json;
    } else {
      return AuthorResponseModel.fromJson(json as Map<String, dynamic>).userId;
    }
  }

  @Deprecated('Technically not intended to be used since this converter is only used for deserialization.')
  @override
  Map<String, dynamic> toJson(String? object) {
    throw UnimplementedError();
  }
}