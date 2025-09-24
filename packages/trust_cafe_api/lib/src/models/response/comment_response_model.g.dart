// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentResponseModel _$CommentResponseModelFromJson(
        Map<String, dynamic> json) =>
    CommentResponseModel(
      statistics: CommentStatisticsResponseModel.fromJson(
          json['statistics'] as Map<String, dynamic>),
      slug: json['slug'] as String,
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      commentText: json['commentText'] as String?,
      sk: json['sk'] as String,
      pk: json['pk'] as String,
      data: CommentDataResponseModel.fromJson(
          json['data'] as Map<String, dynamic>),
      topLevel: CommentOriginResponseModel.fromJson(
          json['topLevel'] as Map<String, dynamic>),
      authors: (json['authors'] as List<dynamic>?)
          ?.map((e) => AuthorResponseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      archived: json['archived'] as bool?,
      deleted: json['deleted'] as bool?,
      blurLabel: json['blurLabel'] as String?,
    );

CommentStatisticsResponseModel _$CommentStatisticsResponseModelFromJson(
        Map<String, dynamic> json) =>
    CommentStatisticsResponseModel(
      authorCount: (json['authorCount'] as num?)?.toInt() ?? 1,
      commentReplies: (json['commentReplies'] as num?)?.toInt() ?? 0,
      revisionCount: (json['revisionCount'] as num?)?.toInt() ?? 0,
      voteCount: (json['voteCount'] as num?)?.toInt() ?? 0,
      voteValueSum: (json['voteValueSum'] as num?)?.toInt() ?? 0,
      reactions: (json['reactions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
    );

CommentDestinationResponseModel _$CommentDestinationResponseModelFromJson(
        Map<String, dynamic> json) =>
    CommentDestinationResponseModel(
      name: json['name'] as String,
      entity: json['entity'] as String,
      slug: json['slug'] as String,
    );

CommentDataResponseModel _$CommentDataResponseModelFromJson(
        Map<String, dynamic> json) =>
    CommentDataResponseModel(
      createdByUser: AuthorResponseModel.fromJson(
          json['createdByUser'] as Map<String, dynamic>),
      post: json['post'] == null
          ? null
          : CommentOriginResponseModel.fromJson(
              json['post'] as Map<String, dynamic>),
      comment: json['comment'] == null
          ? null
          : CommentOriginResponseModel.fromJson(
              json['comment'] as Map<String, dynamic>),
    );

CommentOriginResponseModel _$CommentOriginResponseModelFromJson(
        Map<String, dynamic> json) =>
    CommentOriginResponseModel(
      sk: json['sk'] as String,
      pk: json['pk'] as String,
      slug: json['slug'] as String,
      createdByUser: json['createdByUser'] == null
          ? null
          : AuthorResponseModel.fromJson(
              json['createdByUser'] as Map<String, dynamic>),
    );
