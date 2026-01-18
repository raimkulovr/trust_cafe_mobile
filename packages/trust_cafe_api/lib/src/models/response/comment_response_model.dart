import 'package:json_annotation/json_annotation.dart';
import 'package:trust_cafe_api/src/models/models.dart';

part 'comment_response_model.g.dart';

@JsonSerializable(createToJson: false)
class CommentResponseModel{
  const CommentResponseModel({
    required this.createdAt,
    required this.updatedAt,
    required this.level,
    required this.commentText,
    required this.sk,
    required this.pk,
    required this.data,
    required this.topLevel,
    this.slug,
    this.statistics,
    this.authors,
    this.archived,
    this.deleted,
    this.blurLabel,
  });

  final CommentStatisticsResponseModel? statistics;
  final String? slug;
  final int createdAt;
  final int updatedAt;
  final int level;
  final String? commentText;
  final String sk;
  final String pk;
  final List<AuthorResponseModel>? authors;
  final CommentDataResponseModel data;
  final bool? archived;
  final bool? deleted;
  final CommentOriginResponseModel topLevel;
  final String? blurLabel;

  static const fromJson = _$CommentResponseModelFromJson;

}

@JsonSerializable(createToJson: false)
class CommentStatisticsResponseModel {
  const CommentStatisticsResponseModel({
    this.authorCount = 1,
    this.commentReplies = 0,
    this.revisionCount = 0,
    this.voteCount = 0,
    this.voteValueSum = 0,
    this.reactions,
  });

  final int authorCount;
  final int commentReplies;
  final int revisionCount;
  final int voteCount;
  final int voteValueSum;
  final ReactionsResponseModel? reactions;

  static const fromJson = _$CommentStatisticsResponseModelFromJson;

}

@JsonSerializable(createToJson: false)
class CommentDestinationResponseModel {
  CommentDestinationResponseModel({
    required this.name,
    required this.entity,
    required this.slug,
  });

  final String name;
  final String entity;
  final String slug;

  static const fromJson = _$CommentDestinationResponseModelFromJson;

}

@JsonSerializable(createToJson: false)
class CommentDataResponseModel {
  const CommentDataResponseModel({
    required this.createdByUser,
    this.post,
    this.comment,
  });

  final AuthorResponseModel createdByUser;
  final CommentOriginResponseModel? post;
  final CommentOriginResponseModel? comment;

  static const fromJson = _$CommentDataResponseModelFromJson;

}

@JsonSerializable(createToJson: false)
class CommentOriginResponseModel {
  const CommentOriginResponseModel({
    required this.sk,
    required this.pk,
    this.slug,
    this.createdByUser,
  });

  final String sk;
  final String pk;
  final String? slug;
  final AuthorResponseModel? createdByUser;

  static const fromJson = _$CommentOriginResponseModelFromJson;
}

@JsonSerializable(createToJson: false)
class CreateCommentResponseModel {
  const CreateCommentResponseModel({
    required this.createdAt,
    required this.updatedAt,
    required this.level,
    required this.commentText,
    required this.sk,
    required this.path,
    required this.userslug,
    required this.commentOnPost,
    required this.createdByUser,
    required this.parent,
    this.blurLabel,
    this.statistics,
  });

  final String? blurLabel;
  final String commentText;
  final int createdAt;
  final int updatedAt;
  final int level;
  final String sk;
  final String path;
  final String userslug;

  final CommentStatisticsResponseModel? statistics;
  final CommentOriginResponseModel commentOnPost;
  final AuthorResponseModel createdByUser;
  final CommentParentResponseModel parent;

  static const fromJson = _$CreateCommentResponseModelFromJson;
}

@JsonSerializable(createToJson: false)
class CommentParentResponseModel {
  const CommentParentResponseModel({
    required this.pk,
    required this.sk,
    required this.entity,
    required this.slug,
  });

  final String pk;
  final String sk;
  final String entity;
  final String slug;

  static const fromJson = _$CommentParentResponseModelFromJson;
}
