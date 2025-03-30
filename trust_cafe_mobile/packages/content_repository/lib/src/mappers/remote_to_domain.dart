import 'package:domain_models/domain_models.dart';
import 'package:trust_cafe_api/trust_cafe_api.dart';
import 'package:content_repository/src/mappers/reaction_map_to_domain.dart';

extension PostResponseToDM on PostDetailsResponseModel {
  Post get toDomainModel =>
      Post(
        collaborative: collaborative ?? false,
        statistics: statistics?.toDomainModel ?? PostStatistics.empty,
        createdAt: createdAt,
        postId: postId,
        postText: postText,
        data: data.toDomainModel,
        updatedAt: updatedAt,
        subReply: subReply ?? 0,
        sk: sk,
        cardUrl: cardUrl ?? '',
        pk: pk,
        authors: authors?.map((e) => e.toDomainModel).toList(),
        blurLabel: blurLabel,
        archivedBy: archivedBy,
      );
}

extension PostStatisticsResponseToDM on PostStatisticsResponseModel {
  PostStatistics get toDomainModel =>
      PostStatistics(
        authorCount: authorCount ?? 0,
        commentCount: commentCount ?? 0,
        topLevelCommentCount: topLevelCommentCount ?? 0,
        revisionCount: revisionCount ?? 0,
        voteCount: voteCount ?? 0,
        voteValueSum: voteValueSum ?? 0,
        reactions: reactions?.toDomainModel() ?? const Reactions.empty(),
      );
}

extension AuthorResponseToDM on AuthorResponseModel {
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

extension PostDataResponseToDM on PostDataResponseModel {
  PostData get toDomainModel =>
      PostData(
        createdByUser: createdByUser.toDomainModel,
        subwiki: subwiki?.toDomainModel,
        maintrunk: maintrunk?.toDomainModel,
        userprofile: userprofile?.toDomainModel,
      );
}

extension SubwikiPostOriginResponseToDM on SubwikiPostOriginResponseModel {
  SubwikiPostOrigin get toDomainModel =>
      SubwikiPostOrigin(
        slug: slug,
        sk: sk,
        pk: pk,
        label: label,
      );
}

extension MainTrunkPostOriginResponseToDM on MainTrunkPostOriginResponseModel {
  MainTrunkPostOrigin get toDomainModel =>
      MainTrunkPostOrigin(
        slug: slug,
        sk: sk,
        pk: pk,
      );
}

extension UserProfilePostOriginResponseToDM on UserProfilePostOriginResponseModel {
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

extension PostPageResponseToDM on PostPageResponseModel {
  PostPage toDomainModel(String? pageKey, FeedType feedType) =>
      PostPage(
          postList: postList.map((e) => e.toDomainModel).toList(),
          pageKey: pageKey,
          nextPageKey: lastEvaluatedKey?.toString(yourFeed: feedType==FeedType.yourFeed),
      );

}

extension CommentStatisticsResponseToDM on CommentStatisticsResponseModel {
  CommentStatistics get toDomainModel =>
      CommentStatistics(
        authorCount: authorCount,
        commentReplies: commentReplies,
        revisionCount: revisionCount,
        voteCount: voteCount,
        voteValueSum: voteValueSum,
        reactions: reactions?.toDomainModel() ?? const Reactions.empty(),
      );
}

extension CommentDestinationResponseToDM on CommentDestinationResponseModel {
  CommentDestination get toDomainModel =>
      CommentDestination(
          name: name,
          entity: entity,
          slug: slug,
      );
}

extension CommentOriginResponseToDM on CommentOriginResponseModel {
  CommentOrigin get toDomainModel =>
      CommentOrigin(
          sk: sk,
          pk: pk,
          slug: slug,
          createdByUser: createdByUser?.toDomainModel,
      );
}

extension CommentDataResponseToDM on CommentDataResponseModel {
  CommentData get toDomainModel =>
      CommentData(
          createdByUser: createdByUser.toDomainModel,
          post: post?.toDomainModel,
          comment: comment?.toDomainModel,
      );
}

extension CommentResponseToDM on CommentResponseModel {
  Comment get toDomainModel =>
      Comment(
        path: path,
        statistics: statistics.toDomainModel,
        slug: slug,
        createdAt: createdAt,
        updatedAt: updatedAt,
        topLevelDestination: topLevelDestination.toDomainModel,
        level: level,
        commentText: commentText ?? '',
        subReply: subReply,
        sk: sk,
        pk: pk,
        authors: authors?.map((e) => e.toDomainModel).toList() ?? const [],
        data: data.toDomainModel,
        archived: archived ?? false,
        deleted: deleted ?? false,
        topLevel: topLevel.toDomainModel,
        blurLabel: blurLabel,
      );
}

extension CommentPageResponseToDM on CommentPageResponseModel {
  CommentPage toDomainModel(String? pageKey)
  {
    final allComments = commentList.map((e) => e.toDomainModel).toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // final subComments = allComments.where((element) => element.data.comment!=null);
    // allComments
    //   ..removeWhere((element) => element.subReply>0)
    //   ..forEach((comment) {
    //     for (final subComment in subComments) {
    //       if(subComment.data.comment!.slug == comment.slug){
    //         comment.subReplies.add(subComment);
    //       }
    //     }
    //   });
    return CommentPage(
      commentList: allComments,
      pageKey: pageKey,
      nextPageKey: lastEvaluatedKey?.toString(),
      );
  }
}

extension AppUserVoteResponseToDM on AppUserVoteResponseModel {
  UserVote get toDomainModel =>
      UserVote(
          parentSk: parent.sk,
          parentPk: parent.pk,
          isUp: vote=="up"
      );
}

extension TrustObjectResponseToDM on TrustObjectResponseModel {
  TrustObject get toDomainModel =>
      TrustObject(
        trustLevel: trustLevel,
        pk: pk,
        sk: sk,
        updatedAt: updatedAt,
        createdAt: createdAt,
      );
}

extension SpiderUrlDataResponseToDM on SpiderUrlDataResponseModel {
  SpiderUrlData toDomainModel(String backupUrl, int backupExpiresAt) =>
      SpiderUrlData(
          url: url ?? backupUrl,
          expiresAt: expiresAt!=null ? expiresAt!*1000 : backupExpiresAt,
          fetchData: fetchData?.toDomainModel,
          oembedData: oembedData?.toDomainModel,
      );
}

extension SpiderFetchDataResponseToDM on SpiderFetchDataResponseModel {
  SpiderFetchData get toDomainModel =>
      SpiderFetchData(
          title: title,
          screenshot: screenshot,
          cachedImage: cachedImage,
          description: description ?? ogDescription,
      );
}

extension SpiderOembedDataResponseToDM on SpiderOembedDataResponseModel {
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

extension SubwikiResponseToDM on SubwikiDetailsResponseModel {
  Subwiki get toDomainModel =>
      Subwiki(
          sk: sk,
          pk: pk,
          slug: slug,
          label: subwikiLabel,
          description: subwikiDesc ?? subwikiDescription ?? '',
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

extension SubwikiStatisticsResponseToDM on SubwikiStatisticsResponseModel {
  SubwikiStatistics get toDomainModel =>
      SubwikiStatistics(totalFollowers: totalFollowers, totalPosts: totalPosts, authorCount: authorCount, revisionCount: revisionCount);
}

extension NotificationPageResponseToDM on NotificationPageResponseModel {
  NotificationPage toDomainModel(String? pageKey) =>
      NotificationPage(
          notificationList: notificationList.map((e) => e.toDomainModel,).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt),),
          pageKey: pageKey,
          nextPageKey: lastEvaluatedKey?.toString()
      );
}

extension NotificationResponseToDM on NotificationDetailsResponseModel{
  Notification get toDomainModel =>
    Notification(
        createdAt: createdAt,
        updatedAt: updatedAt ?? createdAt,
        sk: sk,
        pk: pk,
        item: item.toDomainModel,
    );
}

extension NotificationItemResponseToDM on NotificationDetailsItemResponseModel{
  NotificationItem get toDomainModel =>
      NotificationItem(
          initiator: initiator.toDomainModel,
          read: read,
          reason: reason,
          replacements: replacements.toDomainModel,
      );
}

extension NotificationItemReplacementsResponseToDM on NotificationDetailsItemReplacementsResponseModel{
  NotificationItemReplacements get toDomainModel =>
      NotificationItemReplacements(
          postLink: postLink,
          postSnippet: postSnippet,
          newLevel: newLevel,
          ratingPercentage: ratingPercentage,
          commentLink: commentLink,
          commentSnippet: commentSnippet,
      );
}

extension UserprofileResponseToDM on UserprofileResponseModel {
  Userprofile get toDomainModel =>
      Userprofile(
          fname: fname,
          userLanguage: userLanguage,
          lname: lname,
          userId: userId,
          slug: slug,
          userBio: userBio ?? '',
          blocked: blocked,
          createdAt: createdAt,
          updatedAt: updatedAt,
          statistics: statistics.toDomainModel,
          trustLevel: trustLevel,
          trustName: trustName,
          membershipType: membershipType,
          admin: admin,
      );
}

extension UserprofileStatisticsResponseToDM on UserprofileStatisticsResponseModel {
  UserprofileStatistics get toDomainModel =>
      UserprofileStatistics(
        authorCount: authorCount,
        commentCount: commentCount,
        postCount: postCount,
        revisionCount: revisionCount,
        subwikiCount: subwikiCount,
        totalFollowers: totalFollowers,
        totalProfilePosts: totalProfilePosts,
      );
}

extension ChangeDetailsResponseToDM on ChangeDetailsResponseModel {
  Change get toDomainModel =>
      Change(
          changeLabel: changeLabel,
          action: action,
          slug: slug,
          uri: uri,
          createdAt: createdAt,
          changeText: changeText,
          author: author.toDomainModel,
          type: ChangeType.values.firstWhere((e) => e.name==changeTextData.type, orElse: () => ChangeType.unknown,),
          entity: ChangeEntity.values.firstWhere((e) => e.name==changeTextData.entity, orElse: () => ChangeEntity.unknown,),
      );
}