import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

extension PostCacheToDM on PostCacheModel {
  Post get toDomainModel =>
      Post(
        collaborative: collaborative,
        statistics: statistics.toDomainModel,
        createdAt: createdAt,
        postId: postId,
        postText: postText,
        data: data.toDomainModel,
        updatedAt: updatedAt,
        subReply: subReply,
        sk: sk,
        cardUrl: cardUrl ?? '',
        pk: pk,
        authors: authors?.map((e) => e.toDomainModel).toList(),
        blurLabel: blurLabel,
        archivedBy: archivedBy,
      );
}

extension PostStatisticsCacheToDM on PostStatisticsCacheModel {
  PostStatistics get toDomainModel =>
      PostStatistics(
        authorCount: authorCount,
        commentCount: commentCount,
        topLevelCommentCount: topLevelCommentCount,
        revisionCount: revisionCount,
        voteCount: voteCount,
        voteValueSum: voteValueSum,
        reactions: reactions?.toDomainModel ?? const Reactions.empty(),
      );
}

extension AuthorCacheToDm on AuthorCacheModel {
  Author get toDomainModel =>
      Author(
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

extension PostDataCacheToDM on PostDataCacheModel {
  PostData get toDomainModel =>
      PostData(
          createdByUser: createdByUser.toDomainModel,
          subwiki: subwiki?.toDomainModel,
          maintrunk: maintrunk?.toDomainModel,
          userprofile: userprofile?.toDomainModel,
      );
}

extension SubwikiPostOriginCacheToDM on SubwikiPostOriginCacheModel {
  SubwikiPostOrigin get toDomainModel =>
      SubwikiPostOrigin(
        slug: slug,
        sk: sk,
        pk: pk,
        label: label,
      );
}

extension MainTrunkPostOriginCacheToDM on MainTrunkPostOriginCacheModel {
  MainTrunkPostOrigin get toDomainModel =>
      MainTrunkPostOrigin(
        slug: slug,
        sk: sk,
        pk: pk,
      );
}

extension UserProfilePostOriginCacheToDM on UserProfilePostOriginCacheModel {
  UserProfilePostOrigin get toDomainModel =>
      UserProfilePostOrigin(
        slug: slug,
        sk: sk,
        pk: pk,
        fname: fname,
        lname: lname,
        userId: userId,
      );
}

extension PostPageCacheToDM on PostPageCacheModel {
  PostPage toDomainModel(List<Post> domainPostList) =>
      PostPage(
        pageKey: pageKey,
        postList: domainPostList,
        nextPageKey: nextPageKey,
      );
}

extension CommentCacheToDM on CommentCacheModel {
  Comment get toDomainModel =>
      Comment(
        path: path,
        statistics: statistics.toDomainModel,
        slug: slug,
        createdAt: createdAt,
        updatedAt: updatedAt,
        topLevelDestination: topLevelDestination.toDomainModel,
        level: level,
        commentText: commentText,
        subReply: subReply,
        sk: sk,
        pk: pk,
        authors: authors.map((e) => e.toDomainModel).toList(),
        data: data.toDomainModel,
        archived: archived ?? false,
        deleted: deleted ?? false,
        topLevel: topLevel.toDomainModel,
        blurLabel: blurLabel,
      );
}

extension CommentStatisticsCacheToDM on CommentStatisticsCacheModel {
  CommentStatistics get toDomainModel =>
      CommentStatistics(
        authorCount: authorCount,
        commentReplies: commentReplies,
        revisionCount: revisionCount,
        voteCount: voteCount,
        voteValueSum: voteValueSum,
        reactions: reactions?.toDomainModel ?? const Reactions.empty(),
      );
}

extension CommentDestinationCacheToDM on CommentDestinationCacheModel {
  CommentDestination get toDomainModel =>
      CommentDestination(
        name: name,
        entity: entity,
        slug: slug,
      );
}

extension CommentOriginCacheToDM on CommentOriginCacheModel {
  CommentOrigin get toDomainModel =>
      CommentOrigin(
          sk: sk,
          pk: pk,
          slug: slug,
          createdByUser: createdByUser?.toDomainModel
      );
}

extension CommentDataCacheToDM on CommentDataCacheModel {
  CommentData get toDomainModel =>
      CommentData(
        createdByUser: createdByUser.toDomainModel,
        post: post?.toDomainModel,
        comment: comment?.toDomainModel,
      );
}

extension CommentPageCacheToDM on CommentPageCacheModel {
  CommentPage get toDomainModel =>
      CommentPage(
        commentList: commentList.map((e) => e.toDomainModel).toList(),
        pageKey: pageKey,
        nextPageKey: nextPageKey,
      );
}

extension UserVoteCacheToDM on UserVoteCacheModel {
  UserVote get toDomainModel =>
      UserVote(parentSk: parentSk, parentPk: parentPk, isUp: isUp);
}

extension ReactionsCacheToDM on ReactionsCacheModel {
  Reactions get toDomainModel =>
      Reactions(
        blueHeart: blueHeart ?? 0,
        coldSweat: coldSweat ?? 0,
        fingersCrossed: fingersCrossed ?? 0,
        partyingFace: partyingFace ?? 0,
        rage: rage ?? 0,
        relieved: relieved ?? 0,
        rofl: rofl ?? 0,
        sunglasses: sunglasses ?? 0,
        trustBranch: trustBranch ?? 0,
        eyes : eyes ?? 0,
        astonished : astonished ?? 0,
        shrug : shrug ?? 0,
      );
}

extension TrustObjectCacheToDM on TrustObjectCacheModel {
  TrustObject get toDomainModel =>
      TrustObject(
        trustLevel: trustLevel,
        pk: pk,
        sk: sk,
        updatedAt: updatedAt,
        createdAt: createdAt,
      );
}

extension SpiderUrlDataCacheToDM on SpiderUrlDataCacheModel {
  SpiderUrlData get toDomainModel =>
      SpiderUrlData(
        url: url,
        expiresAt: expiresAt,
        fetchData: fetchData?.toDomainModel,
        oembedData: oembedData?.toDomainModel,
      );
}

extension SpiderFetchDataCacheToDM on SpiderFetchDataCacheModel {
  SpiderFetchData get toDomainModel =>
      SpiderFetchData(
        title: title,
        screenshot: screenshot,
        cachedImage: cachedImage,
        description: description,
      );
}

extension SpiderOembedDataCacheToDM on SpiderOembedDataCacheModel {
  SpiderOembedData get toDomainModel =>
      SpiderOembedData(
        type: type,
        title: title,
        thumbnailUrl: thumbnailUrl,
        providerName: providerName,
        html: html,
        authorName: authorName,
        authorUrl: authorUrl,
      );
}

extension SubwikiCacheToDM on SubwikiCacheModel {
  Subwiki get toDomainModel =>
      Subwiki(
        sk: sk,
        pk: pk,
        slug: slug,
        label: subwikiLabel,
        description: subwikiDesc,
        createdAt: createdAt,
        updatedAt: updatedAt,
        statistics: statistics.toDomainModel,
        lang: subwikiLang,
        authors: authors?.map((e) => e.toDomainModel,).toList(),
        createdByUser: createdByUser?.toDomainModel,
        branchIcon: branchIcon,
        orderedListAName: orderedListAName,
        orderedListAValue: orderedListAValue,
      );
}

extension SubwikiStatisticsCacheToDM on SubwikiStatisticsCacheModel {
  SubwikiStatistics get toDomainModel =>
      SubwikiStatistics(totalFollowers: totalFollowers, totalPosts: totalPosts, authorCount: authorCount, revisionCount: revisionCount);
}