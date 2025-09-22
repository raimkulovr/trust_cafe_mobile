import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:content_repository/src/hash_generator.dart';
import 'package:content_repository/src/mappers/remote_to_cache.dart';
import 'package:domain_models/domain_models.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:key_value_storage/key_value_storage.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:translator/translator.dart';
import 'package:trust_cafe_api/trust_cafe_api.dart';

import 'content_local_storage.dart';
import 'mappers/cache_to_domain.dart';
import 'mappers/domain_to_cache.dart';
import 'mappers/remote_to_domain.dart';
import 'mappers/translation_to_cache.dart';
import 'mappers/reaction_map_to_domain.dart';

class ContentRepository {
  ContentRepository({
    required KeyValueStorage noSqlStorage,
    required TrustCafeApi api,
    @visibleForTesting ContentLocalStorage? localStorage,
  }) :
    _localStorage = localStorage ?? ContentLocalStorage(noSqlStorage),
    _api = api,
    _translator= GoogleTranslator();

  final TrustCafeApi _api;
  final ContentLocalStorage _localStorage;
  final GoogleTranslator _translator;

  final BehaviorSubject<List<UserVote>> _userVotesSubject = BehaviorSubject();
  Stream<List<UserVote>> userVotesStream() async* {
    if(!_userVotesSubject.hasValue){
      final storedVotes = await _localStorage.getAppUserVotesList();
      _userVotesSubject.add(storedVotes.map((e) => e.toDomainModel).toList());
    }

    yield* _userVotesSubject.stream;
  }

  Stream<PostPage> getFeedPage({
    String? slug,
    String? pageKey,
    required FetchPolicy fetchPolicy,
    required FeedType feedType,
  }) async*
  {
    final shouldSkipCacheLookup = fetchPolicy == FetchPolicy.networkOnly;

    if(shouldSkipCacheLookup){
      final freshPage = await _getFeedPageFromNetwork(feedType: feedType, slug: slug, pageKey: pageKey);
      yield freshPage;
    } else {
      final cachedPage = await _localStorage.getFeedPage(feedType: feedType, pageKey: pageKey, slug: slug);
      final domainPostList = <Post>[];

      final isFetchPolicyCacheAndNetwork =
          fetchPolicy == FetchPolicy.cacheAndNetwork;

      final isFetchPolicyCachePreferably =
          fetchPolicy == FetchPolicy.cachePreferably;

      final isFetchPolicyNetworkPreferably =
          fetchPolicy == FetchPolicy.networkPreferably;

      final shouldEmitCachedPageInAdvance =
          isFetchPolicyCachePreferably || isFetchPolicyCacheAndNetwork;

      if((shouldEmitCachedPageInAdvance || isFetchPolicyNetworkPreferably) && cachedPage!=null){
        for(final id in cachedPage.postList){
          final domainPost = (await _localStorage.getPost(id))?.toDomainModel;
          if(domainPost!=null){
            domainPostList.add(domainPost);
          }
        }
      }

      if (shouldEmitCachedPageInAdvance && cachedPage != null) {
        yield cachedPage.toDomainModel(domainPostList);
        if (isFetchPolicyCachePreferably) {
          return;
        }
      }

      try {
        final freshPage = await _getFeedPageFromNetwork(feedType: feedType, slug: slug, pageKey: pageKey);
        yield freshPage;
      } catch (_) {
        if (cachedPage != null && isFetchPolicyNetworkPreferably) {
          yield cachedPage.toDomainModel(domainPostList);
          return;
        }
        rethrow;
      }
    }
  }

  Future<PostPage> _getFeedPageFromNetwork ({
    required FeedType feedType,
    String? pageKey,
    String? slug,
  }) async {
    assert(
      (feedType==FeedType.profile || feedType==FeedType.branch) && slug!=null ||
      (feedType==FeedType.forYou || feedType==FeedType.yourFeed || feedType==FeedType.allProfiles || feedType==FeedType.removed) && slug == null,
    'Slug must be provided when fetching posts for profile or branch');

    final apiPage = await switch(feedType){
      FeedType.forYou => _api.getForYouFeedPage(pageKey),
      FeedType.yourFeed => _api.getYourFeedPage(pageKey),
      FeedType.profile => _api.getProfileFeedPage(slug!, pageKey),
      FeedType.branch => _api.getSubwikiFeedPage(slug!, pageKey),
      FeedType.allProfiles => _api.getAllProfilesFeedPage(pageKey),
      FeedType.removed => _api.getRemovedFeedPage(pageKey),
    };

    final shouldEmptyCache = pageKey == null;
    if (shouldEmptyCache) {
      await _localStorage.clearFeedPageList(feedType: feedType, slug: slug);
    }
    final domainPage = apiPage.toDomainModel(pageKey, feedType);
    for(final post in domainPage.postList){
      _localStorage.upsertPost(post.toCacheModel);
    }
    final cachePage = domainPage.toCacheModel(pageKey);
    await _localStorage.upsertFeedPage(feedType: feedType, page: cachePage, slug: slug);
    return domainPage;
  }

  Stream<CommentPage> getCommentPage(String postId, String? pageKey, {
        required FetchPolicy fetchPolicy,
  }) async* {
    final shouldSkipCacheLookup = fetchPolicy == FetchPolicy.networkOnly;

    if(shouldSkipCacheLookup){
      final freshPage = await _getCommentPageFromNetwork(postId, pageKey);
      yield freshPage;
    } else {

      final cachedPage = await _localStorage.getCommentPage(postId, pageKey);

      final isFetchPolicyCacheAndNetwork =
          fetchPolicy == FetchPolicy.cacheAndNetwork;

      final isFetchPolicyCachePreferably =
          fetchPolicy == FetchPolicy.cachePreferably;

      final shouldEmitCachedPageInAdvance =
          isFetchPolicyCachePreferably || isFetchPolicyCacheAndNetwork;

      if (shouldEmitCachedPageInAdvance && cachedPage != null) {
        yield cachedPage.toDomainModel;
        if (isFetchPolicyCachePreferably) {
          return;
        }
      }

      try {
        final freshPage = await _getCommentPageFromNetwork(postId, pageKey);
        yield freshPage;
      } catch (_) {
        final isFetchPolicyNetworkPreferably =
            fetchPolicy == FetchPolicy.networkPreferably;
        if (cachedPage != null && isFetchPolicyNetworkPreferably) {
          yield cachedPage.toDomainModel;
          return;
        }
        rethrow;
      }
    }
  }

  Future<CommentPage> _getCommentPageFromNetwork(String postId, String? pageKey)
  async {
    final apiPage = await _api.getCommentPage(postId, pageKey);

    final shouldEmptyCache = pageKey == null;
    if (shouldEmptyCache) {
      await _localStorage.clearCommentPageList(postId);
    }
    final domainPage = apiPage.toDomainModel(pageKey);
    final cachePage = domainPage.toCacheModel(pageKey);
    await _localStorage.upsertCommentPage(postId, cachePage);

    return domainPage;
  }

  Future<Post?> getPostFromNetwork(String postId) async {
    final apiPost = await _api.getPost(postId);
    if(apiPost!=null) {
      final domainPost = apiPost.toDomainModel;
      await _localStorage.upsertPost(domainPost.toCacheModel);
      return domainPost;
    } else {
      return null;
    }
  }

  Future<List<UserVote>> getUserVotes() async {
    late final List<UserVote> votes;
    try{
      final apiVotes = await _api.getAppUserVotes();
      votes = apiVotes.map((e) => e.toDomainModel).toList();
      await _localStorage.upsertAppUserVotesList(votes.map((e) => e.toCacheModel).toList());
      _userVotesSubject.add(votes);
    } catch (_){
      final cacheVotes = await _localStorage.getAppUserVotesList();
      votes = cacheVotes.map((e) => e.toDomainModel).toList();
    }
    return votes;
  }

  bool? isSubjectUpvoted(String subjectSk) {
    late final bool? vote;
    try {
      vote = _userVotesSubject.value
          .firstWhere((element) => element.parentSk == subjectSk).isUp;
    } catch(_){
      vote = null;
    }

    return vote;
  }

  Future<void> castUserVote({
    required bool? isUp,
    required String sk,
    required String pk,
    required String slug,
    required String userslug,
    required int voteValue,
    Post? post,
    Comment? comment,
  }) async {
    assert(post!=null || comment!=null, 'Either post or comment must be provided');

    final votes = [..._userVotesSubject.value]
      ..removeWhere((element) => element.parentSk == sk);
    if (isUp!=null){
      votes.add(UserVote(parentSk: sk, parentPk: pk, isUp: isUp));
    }
    _userVotesSubject.add(votes);

    try{
      isUp!=null
          ? await _api.castUserVote(isUp: isUp, sk: sk, pk: pk, slug: slug)
          : await _api.archiveUserVote(slug: slug, userSlug: userslug);
      await _localStorage.upsertAppUserVotesList(votes.map((e) => e.toCacheModel).toList());
      if(post!=null){
        await _localStorage.upsertPost(post.toCacheModel);
      } else if(comment!=null){
        await _localStorage.updateComment(pk.substring(5), comment.toCacheModel);
      }
    } catch(e){
      final cacheVotes = await _localStorage.getAppUserVotesList();
      _userVotesSubject.add(cacheVotes.map((e) => e.toDomainModel).toList());
      rethrow;
    }

  }

  Future<({String translation, String from})> translateContent({
    required String itemId,
    required String content,
    String targetLocale = 'en',
  }) async {
    final document = html_parser.parse(content);
    final textContent = document.body?.text ?? '';

    final cachedTranslation = await _localStorage.getTranslation(itemId, LanguageCodes.list[targetLocale] ?? 'English');
    if(cachedTranslation!=null &&
        cachedTranslation.sourceHash == HashGenerator.generateMd5Hash(textContent)) {
      return (
        translation: cachedTranslation.translatedText,
        from: cachedTranslation.sourceLanguage
      );
    }

    final translation = await _translator.translate(textContent, to: targetLocale);
    await _localStorage.upsertTranslation(translation.toCacheModel(itemId));
    return (translation: translation.text, from: translation.sourceLanguage.name);
  }

  Future<Comment> archiveComment({
    required String postId,
    required String sk,
    required String pk,
    required String userSlug,
  }) async {
    final updatedComment = await _api.archiveComment(
        sk: sk,
        pk: pk,
        userSlug: userSlug,
    );
    final domainComment = updatedComment.toDomainModel;
    await _localStorage.updateComment(postId, domainComment.toCacheModel);
    return domainComment;
  }

  Future<Comment> restoreComment({
    required String postId,
    required String sk,
    required String pk,
  }) async {
    final updatedComment = await _api.restoreComment(
        sk: sk,
        pk: pk,
    );
    final domainComment = updatedComment.toDomainModel;
    await _localStorage.updateComment(postId, domainComment.toCacheModel);
    return domainComment;
  }

  Future<Comment> createComment({
    required String postId,
    required String parentSk,
    required String parentPk,
    required String parentSlug,
    required String commentText,
    required String? blurLabel,
  }) async {
    final newComment = await _api.createComment(
        parentSk: parentSk,
        parentPk: parentPk,
        parentSlug: parentSlug,
        commentText: commentText,
        blurLabel: blurLabel,
    );
    final domainComment = newComment.toDomainModel;
    await _localStorage.createComment(postId, domainComment.toCacheModel);
    return domainComment;
  }

  Future<void> archivePost({
    required String postId,
    required String sk,
    required String pk,
    required String userSlug,
  }) async {
    try {
      await _api.archivePost(
        sk: sk,
        pk: pk,
        userSlug: userSlug,
      );
      await _localStorage.removePost(postId);
    } catch(e) {
      rethrow;
    }
  }

  Future<Post> restorePost({
    required String sk,
    required String pk,
  }) async {
    final updatedPost = await _api.restorePost(sk: sk, pk: pk);
    final domainPost = updatedPost.toDomainModel;
    await _localStorage.upsertPost(domainPost.toCacheModel);
    return domainPost;
  }

  Future<String?> getCachedReaction(String sk) async {
    final cachedReaction = await _localStorage.getReaction(sk);
    return cachedReaction;
  }
  Future<String?> getNetworkReaction(String sk) async {
    final reactionResponse = await _api.getReaction(sk);
    if(reactionResponse.reaction!=null){
      await _localStorage.upsertReaction(sk, reactionResponse.reaction!);
    }

    return reactionResponse.reaction;
  }

  Future<(String, Reactions)> castReaction({
    required String reaction,
    required String entity, // this field is kinda useless apparently
    required String pk,
    required String sk,
    required String slug,
    Post? post,
    Comment? comment,
  }) async {
    assert(post!=null || comment!=null, 'Either post or comment must be provided');

    final reactionResult = await _api.castReaction(reaction: reaction, entity: entity, pk: pk, sk: sk, slug: slug);
    if(reactionResult.actionTaken=='remove') await _localStorage.removeReaction(sk);
    if(reactionResult.actionTaken=='add') await _localStorage.upsertReaction(sk, reaction);
    if(reactionResult.actionTaken=='update') await _localStorage.upsertReaction(sk, reaction);

    if(post!=null){
      await _localStorage.upsertPost(post.toCacheModel);
    } else if(comment!=null){
      await _localStorage.updateComment(pk.substring(5), comment.toCacheModel);
    }

    return (reactionResult.actionTaken, reactionResult.reactions.toDomainModel());
  }

  Stream<TrustObject?> getTrustObjectBySlug(String userSlug) async* {
    final cachedTrust = await _localStorage.getTrustObject(userSlug);
    yield cachedTrust?.toDomainModel;

    final response = await _api.getTrustObjectBySlug(userSlug);
    //TODO: error handling i.e. lack of internet connection
    if(response!=null){
      final domainTrustObject = response.toDomainModel;
      await _localStorage.upsertTrustObject(userSlug, domainTrustObject.toCacheModel);
      yield domainTrustObject;
    }
  }

  Future<void> setTrustObject({
    required String userSlug,
    required int trustLevel,
  }) async {
    await _api.setTrustObject(userSlug: userSlug, trustLevel: trustLevel);
  }

  Stream<SpiderUrlData> getSpiderData(String targetUrl, {bool refresh = false}) async* {
    late final SpiderUrlDataCacheModel? cachedData;

    if(!refresh){
      cachedData = await _localStorage.getSpiderData(HashGenerator.generateMd5Hash(targetUrl));
      if(cachedData!=null) yield cachedData.toDomainModel;
    } else {
      cachedData=null;
    }

    if(refresh || cachedData==null ||
        DateTime.fromMillisecondsSinceEpoch(cachedData.expiresAt)
            .isBefore(DateTime.now())){
      try{
        final responseData = await _api.getSpiderData(targetUrl);
        late final SpiderUrlData domainData;

        if(responseData.source=='cache'){
          if(responseData.urlData.isEmpty){
            //Questionable case; Maybe never to occur.
            domainData = SpiderUrlData(
                url: targetUrl,
                expiresAt: DateTime.now().add(const Duration(days: 1))
                    .millisecondsSinceEpoch,
            );
          } else {
            domainData = responseData.urlData.toDomainModel(targetUrl, DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch);
          }
        } else if(responseData.source=='fetch'){
          final expirationDate = DateTime.now().add(const Duration(hours: 1))
              .millisecondsSinceEpoch;
          if(responseData.urlData.isEmpty){
            domainData = SpiderUrlData(
              url: targetUrl,
              expiresAt: expirationDate,
            );
          } else {
            domainData = SpiderUrlData(
              url: targetUrl,
              expiresAt: expirationDate,
              fetchData: responseData.urlData.fetchData?.toDomainModel,
              oembedData: responseData.urlData.oembedData?.toDomainModel,
            );
          }
        } else {
          domainData = SpiderUrlData(
            url: targetUrl,
            expiresAt: DateTime.now().add(const Duration(days: 1))
                .millisecondsSinceEpoch,
          );
        }

        await _localStorage.upsertSpiderData(HashGenerator.generateMd5Hash(targetUrl), domainData.toCacheModel);

        yield domainData;
      } catch (e) {
        log('error trying to fetch spider data: $e');
      }
    }
  }

  Future<Post> createPost({
    required String parentSk,
    required String parentPk,
    required String postText,
    required bool collaborative,
    required String cardUrl,
    required String? blurLabel,
  }) async {
    final newPost = await _api.createPost(
      parentSk: parentSk,
      parentPk: parentPk,
      postText: postText,
      collaborative: collaborative,
      cardUrl: cardUrl,
      blurLabel: blurLabel,
    );
    final domainPost = newPost.toDomainModel;
    await _localStorage.upsertPost(domainPost.toCacheModel);
    return domainPost;
  }

  Future<void> addPostToFeed(String postId, {
    required FeedType feedType,
    required String? feedSlugData,
  }) async {
    await _localStorage.addPostToFeed(postId,
      feedType: feedType,
      feedSlugData: feedSlugData,
    );
  }

  Future<void> removePostFromFeed(String postId, {
    required FeedType feedType,
    required String? feedSlugData,
  }) async {
    await _localStorage.addPostToFeed(postId,
      feedType: feedType,
      feedSlugData: feedSlugData,
    );
  }

  Future<Post> updatePost({
    required String keySk,
    required String keyPk,
    required String keySlug,
    required String postText,
    required bool collaborative,
    required String cardUrl,
    required String? blurLabel,
  }) async {
    final updatedPost = await _api.updatePost(
      keySk: keySk,
      keyPk: keyPk,
      keySlug: keySlug,
      postText: postText,
      collaborative: collaborative,
      cardUrl: cardUrl,
      blurLabel: blurLabel,
    );
    final domainPost = updatedPost.toDomainModel;
    await _localStorage.upsertPost(domainPost.toCacheModel);
    return domainPost;
  }

  Future<Comment> updateComment({
    required String keySk,
    required String keyPk,
    required String keySlug,
    required String commentText,
    required String? blurLabel,
  }) async {
    final updatedComment = await _api.updateComment(
      keySk: keySk,
      keyPk: keyPk,
      keySlug: keySlug,
      commentText: commentText,
      blurLabel: blurLabel,
    );
    final domainComment = updatedComment.toDomainModel;
    await _localStorage.updateComment(keyPk.substring(5), domainComment.toCacheModel);
    return domainComment;
  }

  Future<String> uploadImage({
    required Uint8List file,
    required String fileName,
    required String contentType,
  }) async {
    final imageUrl = await _api.uploadImage(file: file, fileName: fileName, contentType: contentType);
    final cacheManager = DefaultCacheManager();
    await cacheManager.putFile(imageUrl, file);
    return imageUrl;
  }

  Future<(List<Subwiki> subwikiList, DateTime updatedAt)> getSubwikis({bool refresh = false}) async {
    if(refresh) return _fetchAllSubwikis();

    final cachedSubwikis = await _localStorage.getSubwikis();
    if(cachedSubwikis!=null){
      return (cachedSubwikis.subwikiList.map((e) => e.toDomainModel,).toList(), cachedSubwikis.timestamp);
    } else {
      return _fetchAllSubwikis();
    }
  }

  Future<(List<Subwiki> subwikiList, DateTime updatedAt)> _fetchAllSubwikis() async {
    //TODO: this could use some optimisation, as to not cause 100mb+ temporary rise in memory consumption with only two pages
    final List<SubwikiDetailsResponseModel> subwikiList = [];
    final firstPage = await _api.getSubwikis();
    subwikiList.addAll(firstPage.itemList);
    if(firstPage.lastEvaluatedKey!=null){
      String? nextPageKey = firstPage.lastEvaluatedKey!.toString(subwiki: true);
      while(true){
        if(nextPageKey==null) break;
        final nextPage = await _api.getSubwikis(nextPageKey);
        subwikiList.addAll(nextPage.itemList);
        nextPageKey = nextPage.lastEvaluatedKey?.toString(subwiki: true);
      }
    }

    subwikiList.sort((a, b) => a.subwikiLabel.trimLeft().toLowerCase().compareTo(b.subwikiLabel.trimLeft().toLowerCase()));

    final timestamp = DateTime.now();
    await _localStorage.upsertSubwikis(SubwikiListCacheModel(subwikiList: subwikiList.map((e) => e.toCacheModel,).toList(), timestamp: timestamp));
    return (subwikiList.map((e) => e.toDomainModel,).toList(), timestamp);
  }

  Future<void> movePostToUserProfile({
    required String keyPk,
    required String keySk,
    required String postId,
  }) async {
    await _api.movePostToUserProfile(keyPk: keyPk, keySk: keySk);
  }

  Future<void> updatePostBranch({
    required String keyPk,
    required String keySk,
    required String destinationBranchSlug,
    required String postId,
    required Post updatedPost,
  }) async {
    await _api.updatePostBranch(keyPk: keyPk, keySk: keySk, destinationBranchSlug: destinationBranchSlug, postId: postId);
    await _localStorage.upsertPost(updatedPost.toCacheModel);
  }

  Future<NotificationPage> getNotifications(String? offset) async {
    final response = await _api.getNotifications(offset);
    final domainModel = response.toDomainModel(offset);
    return domainModel;
  }

  Future<Userprofile> getUserprofile(String slug) async {
    final response = await _api.getUserprofile(slug);
    final domainModel = response.toDomainModel;
    return domainModel;
  }

  Future<bool> checkIsFollowing(String slug, {required bool isUserprofile}) async {
    final response = await _api.checkIsFollowing(slug, isUserprofile: isUserprofile);
    return response;
  }

  Future<void> createSubscription(String slug, {required bool isUserprofile}) async {
    final response = _api.createSubscription(slug, isUserprofile: isUserprofile);
  }

  Future<void> deleteSubscription(String slug, {required bool isUserprofile}) async {
    final response = _api.deleteSubscription(slug, isUserprofile: isUserprofile);
  }

  Future<Subwiki> getBranch(String slug) async {
    final response = await _api.getBranch(slug);
    final domainModel = response.toDomainModel;
    return domainModel;
  }

  Future<List<Change>> getChanges(String date) async {
    final changes = await _api.getChanges(date);
    final domainChanges = changes.changeList.map((e) => e.toDomainModel,).toList();
    return domainChanges;
  }

}
