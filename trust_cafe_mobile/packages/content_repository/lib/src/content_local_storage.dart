import 'dart:developer';

import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

class ContentLocalStorage {
  const ContentLocalStorage(this.noSqlStorage);
  final KeyValueStorage noSqlStorage;

  static const _firstPageKey = 'first-page';

  Future<void> upsertCommentPage(String postId, CommentPageCacheModel page)
  async {
    final box = await noSqlStorage.commentPagesBox;
    await box.put('${postId}_${page.pageKey ?? _firstPageKey}', page);
  }

  Future<CommentPageCacheModel?> getCommentPage(String postId, String? pageKey)
  async {
    final box = await noSqlStorage.commentPagesBox;
    final postCommentPage = box.get('${postId}_${pageKey ?? _firstPageKey}');
    return postCommentPage;
  }

  Future<void> upsertTranslation(TranslationCacheModel translation)
  async {
    final box = await noSqlStorage.translationsBox;
    await box.put('${translation.targetLanguage}_${translation.itemId}', translation);
  }

  Future<TranslationCacheModel?> getTranslation(String itemId, String targetLanguage)
  async {
    final box = await noSqlStorage.translationsBox;
    final translation = box.get('${targetLanguage}_$itemId');
    return translation;
  }

  Future<void> upsertAppUserVotesList(List<UserVoteCacheModel> votes)
  async {
    final box = await noSqlStorage.appUserVotesBox;
    await box.clear();
    await box.addAll(votes);
  }

  Future<List<UserVoteCacheModel>> getAppUserVotesList()
  async {
    final box = await noSqlStorage.appUserVotesBox;
    return box.values.toList();
  }

  Future<PostCacheModel?> getPost(String postId) async {
    final box = await noSqlStorage.allPostsBox;
    return box.get(postId);
  }

  Future<void> removePost(String postId) async {
    final box = await noSqlStorage.allPostsBox;
    await box.delete(postId);
  }

  Future<void> upsertPost(PostCacheModel post) async {
    final box = await noSqlStorage.allPostsBox;
    await box.put(post.postId, post);
  }

  Future<void> addPostToFeed(String postId, {
    required FeedType feedType,
    required String? feedSlugData,
  }) async {
    final box = await _openFeedPagesBox(feedType);
    try {
      final pageKey = _getSlugPageKey(feedSlugData, _firstPageKey);
      final key = box.keys.firstWhere((key) => key == pageKey,);
      final outdatedPage = box.get(key);
      if(outdatedPage!=null){
        final updatedPostPage = PostPageCacheModel(
          pageKey: outdatedPage.pageKey,
          nextPageKey: outdatedPage.nextPageKey,
          postList: [postId, ...outdatedPage.postList],
        );

        await box.put(pageKey, updatedPostPage);
      }

    } catch (_) {}
  }

  Future<void> removePostFromFeed(String postId, {
    required FeedType feedType,
    required String? feedSlugData,
  }) async {
    final box = await _openFeedPagesBox(feedType);
    try {
      final pageKey = _getSlugPageKey(feedSlugData, _firstPageKey);
      final key = box.keys.firstWhere((key) => key == pageKey,);
      final outdatedPage = box.get(key);
      if(outdatedPage!=null){
        final updatedPostPage = PostPageCacheModel(
          pageKey: outdatedPage.pageKey,
          nextPageKey: outdatedPage.nextPageKey,
          postList: outdatedPage.postList.where((e) => e!=postId,).toList(),
        );

        await box.put(pageKey, updatedPostPage);
      }

    } catch (_) {}
  }

  Future<void> updateComment(String postId, CommentCacheModel updatedComment) async {
    final box = await noSqlStorage.commentPagesBox;
    final pageList = box.values.toList();
    try {
      final outdatedPage = pageList.firstWhere(
            (page) => page.commentList.any(
              (comment) => comment.slug == updatedComment.slug,
        ),
      );

      final updatedCommentPage = CommentPageCacheModel(
        pageKey: outdatedPage.pageKey,
        nextPageKey: outdatedPage.nextPageKey,
        commentList: outdatedPage.commentList.map((comment)
        {
          if (comment.slug == updatedComment.slug) {
            return updatedComment;
          } else {
            return comment;
          }
        }).toList(),
      );

      await box.put('${postId}_${outdatedPage.pageKey ?? _firstPageKey}', updatedCommentPage);

    } catch (_) {
      log('ERROR WHEN CACHING UPDATED COMMENT!!\n$postId, ${updatedComment.slug}');
    }
  }

  Future<void> createComment(String postId, CommentCacheModel newComment) async {
    final box = await noSqlStorage.commentPagesBox;
    try {
      final outdatedPageKey = box.keys.lastWhere((e) => (e as String).startsWith(postId),);
      final outdatedPage = box.get(outdatedPageKey);

      final updatedCommentPage = CommentPageCacheModel(
        pageKey: outdatedPage!.pageKey,
        nextPageKey: outdatedPage.nextPageKey,
        commentList: [...outdatedPage.commentList, newComment],
      );

      await box.put('${postId}_${outdatedPage.pageKey ?? _firstPageKey}', updatedCommentPage);

    } catch (_) {}
  }

  Future<String?> getReaction(String sk) async {
    final box = await noSqlStorage.reactionsBox;
    return box.get(sk);
  }

  Future<TrustObjectCacheModel?> getTrustObject(String userSlug) async {
    final box = await noSqlStorage.trustObjectsBox;
    return box.get(userSlug);
  }

  Future<void> upsertTrustObject(String userSlug, TrustObjectCacheModel object) async {
    final box = await noSqlStorage.trustObjectsBox;
    return box.put(userSlug, object);
  }

  Future<void> upsertReaction(String sk, String reaction) async {
    final box = await noSqlStorage.reactionsBox;
    await box.put(sk, reaction);
  }

  Future<SpiderUrlDataCacheModel?> getSpiderData(String targetUrlHash) async {
    final box = await noSqlStorage.spiderObjectsBox;
    return box.get(targetUrlHash);
  }

  Future<void> upsertSpiderData(String targetUrlHash, SpiderUrlDataCacheModel spiderObject) async {
    final box = await noSqlStorage.spiderObjectsBox;
    return box.put(targetUrlHash, spiderObject);
  }

  Future<SubwikiListCacheModel?> getSubwikis() async {
    final box = await noSqlStorage.subwikisBox;
    return box.get(_firstPageKey);
  }

  Future<void> upsertSubwikis(SubwikiListCacheModel subwikis) async {
    final box = await noSqlStorage.subwikisBox;
    return box.put(_firstPageKey, subwikis);
  }

  Future<void> removeReaction(String sk) async {
    final box = await noSqlStorage.reactionsBox;
    await box.delete(sk);
  }

  Future<void> clearCommentPageList(String postId) async {
    final box = await noSqlStorage.commentPagesBox;
    final keys = box.keys.where((element) => (element as String).startsWith(postId),);
    if(keys.isEmpty) return;
    keys.forEach((element) async => box.delete(element),);
  }

  Future<void> upsertFeedPage({
    required FeedType feedType,
    required PostPageCacheModel page,
    String? slug,
  }) async {
    assert(
    (feedType==FeedType.profile || feedType==FeedType.branch) && slug!=null ||
        (feedType==FeedType.forYou || feedType==FeedType.yourFeed || feedType==FeedType.allProfiles || feedType==FeedType.removed) && slug == null,
    'Slug must be provided when setting posts for profile or branch');

    final box = await _openFeedPagesBox(feedType);
    await box.put('${_getSlugPageKey(slug, page.pageKey)}', page);
  }

  Future<PostPageCacheModel?> getFeedPage({
    required FeedType feedType,
    String? pageKey,
    String? slug,
  })
  async {
    assert(
    (feedType==FeedType.profile || feedType==FeedType.branch) && slug!=null ||
        (feedType==FeedType.forYou || feedType==FeedType.yourFeed || feedType==FeedType.allProfiles || feedType==FeedType.removed) && slug == null,
    'Slug must be provided when getting posts for profile or branch');

    final box = await _openFeedPagesBox(feedType);
    return box.get('${_getSlugPageKey(slug, pageKey)}');
  }

  Future<void> clearFeedPageList({
    required FeedType feedType,
    String? slug,
  }) async {
    assert(
    (feedType==FeedType.profile || feedType==FeedType.branch) && slug!=null ||
        (feedType==FeedType.forYou || feedType==FeedType.yourFeed || feedType==FeedType.allProfiles || feedType==FeedType.removed) && slug == null,
    'Slug must be provided when clearing posts for profile or branch');

    final box = await _openFeedPagesBox(feedType);
    if(feedType==FeedType.profile || feedType==FeedType.branch){
      final keys = box.keys.where((element) => (element as String).startsWith(slug!),);
      keys.forEach((element) => box.delete(element),);
    } else {
      await box.clear();
    }
  }

  String _getSlugPageKey(String? slug, String? pageKey) => slug!=null? '${slug}_' : ''+ (pageKey ?? _firstPageKey);
  Future<Box<PostPageCacheModel>> _openFeedPagesBox(FeedType feedType){
    return switch(feedType){
      FeedType.forYou => noSqlStorage.forYouFeedPagesBox,
      FeedType.yourFeed => noSqlStorage.yourFeedPagesBox,
      FeedType.profile => noSqlStorage.profileFeedPagesBox,
      FeedType.branch => noSqlStorage.branchFeedPagesBox,
      FeedType.allProfiles => noSqlStorage.allProfilesFeedPagesBox,
      FeedType.removed => noSqlStorage.removedFeedPagesBox,
    };
  }

}
