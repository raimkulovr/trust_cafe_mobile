import 'package:json_annotation/json_annotation.dart';
import 'package:trust_cafe_api/src/models/response/author_response_model.dart';

part 'subwiki_details_response_model.g.dart';

@JsonSerializable(createToJson: false)
class SubwikiDetailsResponseModel {
  const SubwikiDetailsResponseModel({
    required this.sk,
    required this.pk,
    required this.slug,
    required this.subwikiLabel,
    required this.createdAt,
    required this.updatedAt,
    required this.statistics,
    this.subwikiDesc,
    this.subwikiDescription,
    this.subwikiLang,
    this.authors,
    this.createdByUser,
    this.branchIcon,
    this.orderedListAName,
    this.orderedListAValue,
  });

  final String sk;
  final String pk;
  final String slug;
  final String subwikiLabel;
  final String? subwikiDesc;
  final String? subwikiDescription;
  final int createdAt;
  final int updatedAt;
  final SubwikiStatisticsResponseModel statistics;
  final String? subwikiLang;
  final List<AuthorResponseModel>? authors;
  @SubwikiCreatorConverter()
  @JsonKey(name: 'data')
  final AuthorResponseModel? createdByUser;
  final String? branchIcon;
  final String? orderedListAName;
  final double? orderedListAValue;

  static const fromJson = _$SubwikiDetailsResponseModelFromJson;

}

@JsonSerializable(createToJson: false)
class SubwikiStatisticsResponseModel{
  const SubwikiStatisticsResponseModel({
    required this.totalFollowers,
    required this.totalPosts,
    this.authorCount,
    this.revisionCount,
  });

  final int totalFollowers;
  final int totalPosts;
  final int? authorCount;
  final int? revisionCount;

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