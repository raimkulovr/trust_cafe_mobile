// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDetailsResponseModel _$PostDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    PostDetailsResponseModel(
      collaborative: json['collaborative'] as bool?,
      statistics: json['statistics'] == null
          ? null
          : PostStatisticsResponseModel.fromJson(
              json['statistics'] as Map<String, dynamic>),
      createdAt: (json['createdAt'] as num).toInt(),
      postId: json['postID'] as String,
      postText: json['postText'] as String,
      data:
          PostDataResponseModel.fromJson(json['data'] as Map<String, dynamic>),
      updatedAt: (json['updatedAt'] as num).toInt(),
      subReply: (json['subReply'] as num?)?.toInt(),
      sk: json['sk'] as String,
      cardUrl: json['cardUrl'] as String?,
      pk: json['pk'] as String,
      authors: (json['authors'] as List<dynamic>?)
          ?.map((e) => AuthorResponseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      blurLabel: json['blurLabel'] as String?,
      archivedBy: const ArchivedByConverter().fromJson(json['archivedBy']),
    );

PostDataResponseModel _$PostDataResponseModelFromJson(
        Map<String, dynamic> json) =>
    PostDataResponseModel(
      createdByUser: AuthorResponseModel.fromJson(
          json['createdByUser'] as Map<String, dynamic>),
      subwiki: json['subwiki'] == null
          ? null
          : SubwikiPostOriginResponseModel.fromJson(
              json['subwiki'] as Map<String, dynamic>),
      maintrunk: json['maintrunk'] == null
          ? null
          : MainTrunkPostOriginResponseModel.fromJson(
              json['maintrunk'] as Map<String, dynamic>),
      userprofile: json['userprofile'] == null
          ? null
          : UserProfilePostOriginResponseModel.fromJson(
              json['userprofile'] as Map<String, dynamic>),
    );

SubwikiPostOriginResponseModel _$SubwikiPostOriginResponseModelFromJson(
        Map<String, dynamic> json) =>
    SubwikiPostOriginResponseModel(
      slug: json['slug'] as String?,
      sk: json['sk'] as String?,
      pk: json['pk'] as String?,
      label: json['label'] as String?,
    );

MainTrunkPostOriginResponseModel _$MainTrunkPostOriginResponseModelFromJson(
        Map<String, dynamic> json) =>
    MainTrunkPostOriginResponseModel(
      slug: json['slug'] as String?,
      sk: json['sk'] as String?,
      pk: json['pk'] as String?,
    );

UserProfilePostOriginResponseModel _$UserProfilePostOriginResponseModelFromJson(
        Map<String, dynamic> json) =>
    UserProfilePostOriginResponseModel(
      slug: json['slug'] as String?,
      sk: json['sk'] as String?,
      pk: json['pk'] as String?,
      fname: json['fname'] as String?,
      lname: json['lname'] as String?,
      userId: json['userID'] as String?,
    );

PostStatisticsResponseModel _$PostStatisticsResponseModelFromJson(
        Map<String, dynamic> json) =>
    PostStatisticsResponseModel(
      authorCount: (json['authorCount'] as num?)?.toInt(),
      commentCount: (json['commentCount'] as num?)?.toInt(),
      topLevelCommentCount: (json['commentCountTopLevel'] as num?)?.toInt(),
      revisionCount: (json['revisionCount'] as num?)?.toInt(),
      voteCount: (json['voteCount'] as num?)?.toInt(),
      voteValueSum: (json['voteValueSum'] as num?)?.toInt(),
      reactions: (json['reactions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
    );
