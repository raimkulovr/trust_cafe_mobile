import 'package:domain_models/src/page.dart';
import 'package:equatable/equatable.dart';

import 'author.dart';

class NotificationPage extends Page {
  const NotificationPage({
    required this.notificationList,
    super.pageKey,
    super.nextPageKey,
  });

  final List<Notification> notificationList;

  @override
  List<Object?> get props =>
      [
        ...super.props,
        notificationList,
      ];

}

class Notification extends Equatable{
  const Notification({
    required this.createdAt,
    required this.updatedAt,
    required this.sk,
    required this.pk,
    required this.item,
  });

  final int createdAt;
  final int updatedAt;
  final String sk;
  final String pk;
  final NotificationItem item;

  bool get isArticleUpdated => item.reason == 'article_updated';
  bool get isCommentReply => item.reason == 'comment_reply';
  bool get isProfilePost => item.reason == 'profile_post';
  bool get isRankUp => item.reason == 'rank_up';
  bool get isTrustBoost => item.reason == 'trust_created';

  String get reason => switch(item.reason){
    "article_updated"=> "updated your post",
    "comment_reply"=> "replied to you",
    "profile_post"=> "posted on your profile",
    "rank_up"=> "You were promoted",
    "trust_created"=> "gave you",
    _ => '',
  };

  @override
  List<Object> get props => [createdAt, updatedAt, sk, pk, item];

}

class NotificationItem extends Equatable {
  const NotificationItem({
    required this.initiator,
    required this.read,
    required this.reason,
    required this.replacements,
  });

  final Author initiator;
  final bool read;
  final String reason;
  final NotificationItemReplacements replacements;

  @override
  List<Object> get props => [initiator, read, reason, replacements];

}

class NotificationItemReplacements extends Equatable {
  const NotificationItemReplacements({
    this.postLink,
    this.postSnippet,
    this.newLevel,
    this.ratingPercentage,
    this.commentLink,
    this.commentSnippet,
  });

  final String? postLink;
  final String? postSnippet;
  final String? newLevel;
  final int? ratingPercentage;
  final String? commentLink;
  final String? commentSnippet;

  @override
  List<Object?> get props =>
      [
        postLink,
        postSnippet,
        newLevel,
        ratingPercentage,
        commentLink,
        commentSnippet,
      ];

}