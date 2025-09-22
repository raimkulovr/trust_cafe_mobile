import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

extension PostDomainToCM on Post {
  PostCacheModel get toCacheModel =>
      PostCacheModel(
        collaborative: collaborative,
        statistics: statistics.toCacheModel,
        createdAt: createdAt,
        postId: postId,
        postText: postText,
        data: data.toCacheModel,
        updatedAt: updatedAt,
        subReply: subReply,
        sk: sk,
        cardUrl: cardUrl,
        pk: pk,
        authors: authors?.map((e) => e.toCacheModel).toList(),
        blurLabel: blurLabel,
        archivedBy: archivedBy,
      );
}

extension PostStatisticsDomainToCM on PostStatistics {
  PostStatisticsCacheModel get toCacheModel =>
      PostStatisticsCacheModel(
        authorCount: authorCount,
        commentCount: commentCount,
        topLevelCommentCount: topLevelCommentCount,
        revisionCount: revisionCount,
        voteCount: voteCount,
        voteValueSum: voteValueSum,
        reactions: reactions.toCacheModel(),
      );
}

extension AuthorDomainToCm on Author {
  AuthorCacheModel get toCacheModel =>
      AuthorCacheModel(
        fname: fname,
        userLanguage: userLanguage,
        lname: lname,
        userId: userId,
        slug: slug,
        trustLevel: trustLevel,
        trustName: trustName,
        membershipType: membershipType,
      );
}

extension PostDataDomainToCM on PostData {
  PostDataCacheModel get toCacheModel =>
      PostDataCacheModel(
        createdByUser: createdByUser.toCacheModel,
        subwiki: subwiki?.toCacheModel,
        maintrunk: maintrunk?.toCacheModel,
        userprofile: userprofile?.toCacheModel,
      );
}

extension SubwikiPostOriginDomainToCM on SubwikiPostOrigin {
  SubwikiPostOriginCacheModel get toCacheModel =>
      SubwikiPostOriginCacheModel(
        slug: slug,
        sk: sk,
        pk: pk,
        label: label,
      );
}

extension MainTrunkPostOriginDomainToCM on MainTrunkPostOrigin {
  MainTrunkPostOriginCacheModel get toCacheModel =>
      MainTrunkPostOriginCacheModel(
        slug: slug,
        sk: sk,
        pk: pk,
      );
}

extension UserProfilePostOriginDomainToCM on UserProfilePostOrigin {
  UserProfilePostOriginCacheModel get toCacheModel =>
      UserProfilePostOriginCacheModel(
        slug: slug,
        sk: sk,
        pk: pk,
        fname: fname,
        lname: lname,
        userId: userId,
      );
}

extension PostPageDomainToCM on PostPage {
  PostPageCacheModel toCacheModel(String? pageKey) =>
      PostPageCacheModel(
        postList: postList.map((e) => e.postId).toList(),
        pageKey: pageKey,
        nextPageKey: nextPageKey,
      );
}

extension CommentDomainToCM on Comment {
  CommentCacheModel get toCacheModel =>
      CommentCacheModel(
          statistics: statistics.toCacheModel,
          slug: slug,
          createdAt: createdAt,
          updatedAt: updatedAt,
          level: level,
          commentText: commentText,
          sk: sk,
          pk: pk,
          authors: authors.map((e) => e.toCacheModel).toList(),
          data: data.toCacheModel,
          archived: archived,
          deleted: deleted,
          topLevel: topLevel.toCacheModel,
          blurLabel: blurLabel,
      );
}

extension CommentStatisticsDomainToCM on CommentStatistics {
  CommentStatisticsCacheModel get toCacheModel =>
      CommentStatisticsCacheModel(
          authorCount: authorCount,
          commentReplies: commentReplies,
          revisionCount: revisionCount,
          voteCount: voteCount,
          voteValueSum: voteValueSum,
          reactions: reactions.toCacheModel(),
      );
}

extension CommentDestinationDomainToCM on CommentDestination {
  CommentDestinationCacheModel get toCacheModel =>
      CommentDestinationCacheModel(
          name: name,
          entity: entity,
          slug: slug,
      );
}

extension CommentOriginDomainToCM on CommentOrigin {
  CommentOriginCacheModel get toCacheModel =>
      CommentOriginCacheModel(
          sk: sk,
          pk: pk,
          slug: slug,
          createdByUser: createdByUser?.toCacheModel
      );
}

extension CommentDataDomainToCM on CommentData {
  CommentDataCacheModel get toCacheModel =>
      CommentDataCacheModel(
          createdByUser: createdByUser.toCacheModel,
          post: post?.toCacheModel,
          comment: comment?.toCacheModel,
      );
}

extension CommentPageDomainToCM on CommentPage {
  CommentPageCacheModel toCacheModel(String? pageKey) =>
      CommentPageCacheModel(
        commentList: commentList.map((e) => e.toCacheModel).toList(),
        pageKey: pageKey,
        nextPageKey: nextPageKey,
      );
}

extension UserVoteDomainToCM on UserVote {
  UserVoteCacheModel get toCacheModel =>
      UserVoteCacheModel(parentSk: parentSk, parentPk: parentPk, isUp: isUp);
}

extension ReactionsDomainToCM on Reactions {
  ReactionsCacheModel toCacheModel() {
    final Map<String, int> reactions = {};

    values.forEach((key, value) {
      reactions[key.name] = value;
    },);

    return ReactionsCacheModel(values: reactions);
  }
}

extension TrustObjectDomainToCM on TrustObject {
  TrustObjectCacheModel get toCacheModel =>
      TrustObjectCacheModel(
        trustLevel: trustLevel,
        pk: pk,
        sk: sk,
        updatedAt: updatedAt,
        createdAt: createdAt,
      );
}

extension SpiderUrlDataDomainToCM on SpiderUrlData {
  SpiderUrlDataCacheModel get toCacheModel =>
      SpiderUrlDataCacheModel(
        url: url,
        expiresAt: expiresAt,
        fetchData: fetchData?.toCacheModel,
        oembedData: oembedData?.toCacheModel,
      );
}

extension SpiderFetchDataDomainToCM on SpiderFetchData {
  SpiderFetchDataCacheModel get toCacheModel =>
      SpiderFetchDataCacheModel(
        title: title,
        screenshot: screenshot,
        cachedImage: cachedImage,
        description: description,
      );
}

extension SpiderOembedDataDomainToCM on SpiderOembedData {
  SpiderOembedDataCacheModel get toCacheModel =>
      SpiderOembedDataCacheModel(
        type: type,
        title: title,
        thumbnailUrl: thumbnailUrl,
        providerName: providerName,
        html: html,
        authorName: authorName,
        authorUrl: authorUrl,
      );
}