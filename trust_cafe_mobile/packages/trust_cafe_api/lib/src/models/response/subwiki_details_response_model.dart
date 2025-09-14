import 'package:json_annotation/json_annotation.dart';
import 'package:trust_cafe_api/src/models/response/author_response_model.dart';

part 'subwiki_details_response_model.g.dart';

@JsonSerializable(createToJson: false)
class SubwikiDetailsResponseModel {
  const SubwikiDetailsResponseModel({
    required this.slug,
    required this.subwikiLabel,
    this.createdAt = 0,
    this.statistics = const SubwikiStatisticsResponseModel(),
    this.subwikiLang = "",
    this.branchIcon = "",
    this.branchColor = "",
    this.branchSummary = "",
    this.branchID = "",
    this.isFollowing = false,
  });

  final String slug;
  final String subwikiLabel;
  final int createdAt;
  final SubwikiStatisticsResponseModel statistics;
  final String subwikiLang;
  final String branchIcon;
  final String branchColor;
  final String branchSummary;
  final String branchID;
  final bool isFollowing;

  static const fromJson = _$SubwikiDetailsResponseModelFromJson;

}

@JsonSerializable(createToJson: false)
class SubwikiStatisticsResponseModel{
  const SubwikiStatisticsResponseModel({
    this.totalFollowers = 0,
    this.totalPosts = 0,
    this.authorCount = 0,
    this.revisionCount = 0,
  });

  final int totalFollowers;
  final int totalPosts;
  final int authorCount;
  final int revisionCount;

  static const fromJson = _$SubwikiStatisticsResponseModelFromJson;

}

class SubwikiCreatorConverter
    extends JsonConverter<AuthorResponseModel?, Map<String, dynamic>> {
  const SubwikiCreatorConverter();

  @override
  AuthorResponseModel? fromJson(Map<String, dynamic> json) {
    late final AuthorResponseModel? author;
    try{
      author = AuthorResponseModel.fromJson(json['createdByUser'] as Map<String, dynamic>);
    } catch (e) {
      author = null;
    }
    return author;
  }

  @Deprecated('Technically not intended to be used since this converter is only used for deserialization.')
  @override
  Map<String, dynamic> toJson(AuthorResponseModel? object) {
    throw UnimplementedError();
  }
}