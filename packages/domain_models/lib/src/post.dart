import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  const Post({
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
    required this.blurLabel,
    required this.archivedBy,
  });

  final bool collaborative;
  final PostStatistics statistics;
  final int createdAt;
  final String postId;
  final String postText;
  final PostData data;
  final int updatedAt;
  final int subReply;
  // "sk": "post#1730376044592-85346010"
  final String sk;
  //"pk": "subwiki#pink-floyd"
  final String pk;
  final String cardUrl;
  final List<Author>? authors;
  final String? blurLabel;
  final String? archivedBy;

  bool get isArchived => archivedBy!=null;

  @override
  List<Object?> get props => [
    collaborative,
    statistics,
    createdAt,
    postId,
    postText,
    data,
    updatedAt,
    subReply,
    sk,
    cardUrl,
    pk,
    authors,
    blurLabel,
    archivedBy,
  ];

  Post copyWith({
    bool? collaborative,
    PostStatistics? statistics,
    int? createdAt,
    String? postId,
    String? postText,
    PostData? data,
    int? updatedAt,
    int? subReply,
    String? sk,
    String? pk,
    String? cardUrl,
    Wrapped<List<Author>?>? authors,
    Wrapped<String?>? blurLabel,
    Wrapped<String?>? archivedBy,
  }) {
    return Post(
      collaborative: collaborative ?? this.collaborative,
      statistics: statistics ?? this.statistics,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      postText: postText ?? this.postText,
      data: data ?? this.data,
      updatedAt: updatedAt ?? this.updatedAt,
      subReply: subReply ?? this.subReply,
      sk: sk ?? this.sk,
      pk: pk ?? this.pk,
      cardUrl: cardUrl ?? this.cardUrl,
      authors: authors !=null ? authors.value : this.authors,
      blurLabel: blurLabel !=null ? blurLabel.value : this.blurLabel,
      archivedBy: archivedBy !=null ? archivedBy.value : this.archivedBy,
    );
  }

  static const empty = Post(
      collaborative: false,
      statistics: PostStatistics.empty,
      createdAt: 0,
      postId: '',
      postText: '',
      data: PostData(createdByUser: Author.system, subwiki: null, maintrunk: null, userprofile: null),
      updatedAt: 0,
      subReply: 0,
      sk: '',
      cardUrl: '',
      pk: '',
      authors: [],
      blurLabel: null,
      archivedBy: null,
  );
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  static const notFound = Post(
    collaborative: false,
    statistics: PostStatistics.empty,
    createdAt: 0,
    postId: 'notFound',
    postText: '',
    data: PostData(createdByUser: Author.system, subwiki: null, maintrunk: null, userprofile: null),
    updatedAt: 0,
    subReply: 0,
    sk: '',
    cardUrl: '',
    pk: '',
    authors: [],
    blurLabel: null,
    archivedBy: null,
  );
  bool get isNotFound => this == notFound;

}

class PostStatistics extends Equatable {
  const PostStatistics({
    required this.authorCount,
    required this.commentCount,
    required this.topLevelCommentCount,
    required this.revisionCount,
    required this.voteCount,
    required this.voteValueSum,
    required this.reactions,
  });
  final int authorCount;
  final int commentCount;
  final int topLevelCommentCount;
  final int revisionCount;
  final int voteCount;
  final int voteValueSum;
  final Reactions reactions;

  @override
  List<Object?> get props => [
    authorCount,
    commentCount,
    topLevelCommentCount,
    revisionCount,
    voteCount,
    voteValueSum,
    reactions,
  ];

  PostStatistics copyWith({
    int? authorCount,
    int? commentCount,
    int? topLevelCommentCount,
    int? revisionCount,
    int? voteCount,
    int? voteValueSum,
    Reactions? reactions,
  }) {
    return PostStatistics(
      authorCount: authorCount ?? this.authorCount,
      commentCount: commentCount ?? this.commentCount,
      topLevelCommentCount: topLevelCommentCount ?? this.topLevelCommentCount,
      revisionCount: revisionCount ?? this.revisionCount,
      voteCount: voteCount ?? this.voteCount,
      voteValueSum: voteValueSum ?? this.voteValueSum,
      reactions: reactions ?? this.reactions,
    );
  }

  static const empty = PostStatistics(authorCount: 0, commentCount: 0, topLevelCommentCount: 0, revisionCount: 0, voteCount: 0, voteValueSum: 0, reactions: Reactions.empty());
}

class PostData extends Equatable{
  const PostData({
    required this.createdByUser,
    required this.subwiki,
    required this.maintrunk,
    required this.userprofile,
  });
  final Author createdByUser;
  final SubwikiPostOrigin? subwiki;
  final MainTrunkPostOrigin? maintrunk;
  final UserProfilePostOrigin? userprofile;

  String get originPkSk => maintrunk?.sk ?? subwiki?.sk ?? userprofile?.sk ?? '';

  @override
  List<Object?> get props => [
    createdByUser,
    subwiki,
    maintrunk,
    userprofile,
  ];

  PostData copyWith({
    Author? createdByUser,
    Wrapped<SubwikiPostOrigin?>? subwiki,
    Wrapped<MainTrunkPostOrigin?>? maintrunk,
    Wrapped<UserProfilePostOrigin?>? userprofile,
  }) {
    return PostData(
      createdByUser: createdByUser ?? this.createdByUser,
      subwiki: subwiki!=null ? subwiki.value : this.subwiki,
      maintrunk: maintrunk!=null ? maintrunk.value : this.maintrunk,
      userprofile: userprofile!=null ? userprofile.value : this.userprofile,
    );
  }
}

abstract class PostOrigin extends Equatable {
  const PostOrigin({
    this.slug,
    this.sk,
    this.pk,
  });
  final String? slug;
  final String? sk;
  final String? pk;
  bool get originIsValid => slug!=null && sk!=null && pk!=null;

  @override
  List<Object?> get props => [
        slug,
        sk,
        pk,
      ];
}

class SubwikiPostOrigin extends PostOrigin {
  SubwikiPostOrigin({
    super.slug,
    super.sk,
    super.pk,
    this.label,
  });
  final String? label;
  bool get isValid => originIsValid && label!=null;

  @override
  List<Object?> get props => [
        ...super.props,
        label,
      ];
}

class MainTrunkPostOrigin extends PostOrigin {
  MainTrunkPostOrigin({
    super.slug,
    super.sk,
    super.pk,
  });

  bool get isValid => originIsValid;
  @override
  String toString() {
    return 'The Trunk';
  }
}

class UserProfilePostOrigin extends PostOrigin {
  UserProfilePostOrigin({
    super.slug,
    super.sk,
    super.pk,
    this.fname,
    this.lname,
    this.userId,
  });
  final String? fname;
  final String? lname;
  final String? userId;
  bool get isValid => originIsValid && fname !=null && lname !=null && userId !=null;

  String get fullName => '$fname $lname';

  @override
  List<Object?> get props => [
        ...super.props,
        fname,
        lname,
        userId,
      ];
}
