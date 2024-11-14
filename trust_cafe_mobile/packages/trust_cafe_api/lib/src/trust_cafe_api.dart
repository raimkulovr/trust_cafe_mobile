import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trust_cafe_api/src/models/models.dart';
import 'package:trust_cafe_api/src/url_builder.dart';

import 'package:http/http.dart' as http;

typedef TokenSupplier = Future<ApiTokenData?> Function();

class TrustCafeApi {

  Completer<String>? _refreshCompleter;
  TrustCafeApi({
    required TokenSupplier tokenSupplier,
    required ApiChannelSupplier channelSupplier,
    @visibleForTesting Dio? dio,
    @visibleForTesting UrlBuilder? urlBuilder,
  })  : _dio = dio ?? Dio(BaseOptions(
      receiveTimeout: const Duration(seconds: 15),
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
  )),
        _urlBuilder = urlBuilder ?? UrlBuilder(channelSupplier) {
    _dio.interceptors.addAll([
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {

          late final String accessToken;

          final refreshCompleter = _refreshCompleter;
          if (refreshCompleter != null) {
            try {
              accessToken = await refreshCompleter.future;
            } catch (e) {
              rethrow;
            }
          } else {
            final tokenData = _authCredentialsBehaviorSubject.valueOrNull?.tokenData ?? await tokenSupplier();
            try {
              if (tokenData != null) {
                if (tokenData.isNotExpired) {
                  accessToken = tokenData.accessToken;
                } else {
                  _refreshCompleter = Completer<String>();
                  accessToken = await refreshToken(tokenData.accessToken, tokenData.refreshToken);
                }
              } else {
                _refreshCompleter = Completer<String>();
                accessToken = getGuestToken();
              }
              _refreshCompleter?.complete(accessToken);
            } catch (e) {
              try {
                _refreshCompleter = Completer<String>();
                accessToken = getGuestToken();
                _refreshCompleter?.complete(accessToken);
              } catch (e) {
                _refreshCompleter?.completeError(ServerNotAvailableTCApiException());
                throw ServerNotAvailableTCApiException();
              }
            } finally {
              _refreshCompleter = null;
            }
          }

          options.headers['Authorization'] = 'Bearer $accessToken';
          handler.next(options);
        },
      ),
      LogInterceptor(
        requestBody: true,
        request: false,
        responseHeader: false,
        logPrint: (object) => log(object.toString()),)
    ]);
  }

  bool isGuest = true;

  final Dio _dio;
  final UrlBuilder _urlBuilder;

  final BehaviorSubject<AuthCredentialsResponseModel>
      _authCredentialsBehaviorSubject = BehaviorSubject();

  /// Future responses from [refreshToken] are exposed into a stream so that
  /// new credentials could be saved in a secured storage by the consumer
  /// of this class.
  Stream<AuthCredentialsResponseModel> authCredentialsStream() =>
      _authCredentialsBehaviorSubject.stream;

  String getGuestToken() {
    const newCredentials = AuthCredentialsResponseModel.guest;
    _authCredentialsBehaviorSubject.add(newCredentials);
    isGuest = true;
    return newCredentials.tokenData.accessToken;
  }

  Future<String> refreshToken(String accessToken, String refreshToken) async {
    if(isGuest) return getGuestToken();
    final url = _urlBuilder.refreshTokenUrl(refreshToken);
    final dio = Dio()..interceptors.add(LogInterceptor(request: false, responseHeader: false,
      logPrint: (object) => log(object.toString()),));
    try {
      final response = await dio.post(url,
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      final newAccessToken = _parseNewTokenCredentials(response);
      return newAccessToken;
    } catch(e){
      if(e is DioException){
        if ((e.response?.data  as Map<String, dynamic>)['message']
            == 'User is not authorized to access this resource with an explicit deny') {
          return getGuestToken();
        }
      }
      rethrow;
    }
  }

  Future<void> authenticateUser({
    required AuthCredentialsResponseModel newCredentials,
  }) async {
    _authCredentialsBehaviorSubject.add(newCredentials);
    isGuest = false;
  }

  String _parseNewTokenCredentials(Response response){
    final jsonObject = response.data as Map<String, dynamic>;
    final newCredentials = AuthCredentialsResponseModel.fromJson(jsonObject);
    log('[API] NEW TOKEN CREDENTIALS:\n'
        '${newCredentials.tokenData.accessToken}\n'
        '${newCredentials.tokenData.refreshToken}\n'
        '${newCredentials.tokenData.accessTimeOut}\n\n'
        '${newCredentials.userData.userId}');
    _authCredentialsBehaviorSubject.add(newCredentials);
    // _authCredentialsBehaviorSubject.add(AuthCredentialsResponseModel(userData: newCredentials.userData, tokenData: TokenDataResponseModel(
    //     accessToken: newCredentials.tokenData.accessToken,
    //     refreshToken: newCredentials.tokenData.refreshToken,
    //     accessTimeOut: DateTime.now().add((Duration(seconds: 30))).millisecondsSinceEpoch)));
    return newCredentials.tokenData.accessToken;
  }

  Future<PostPageResponseModel> getForYouFeedPage(String? offset) async {
    final url = _urlBuilder.forYouFeedUrl(offset);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    final postListPage = PostPageResponseModel.fromJson(jsonObject);
    return postListPage;
  }

  Future<PostPageResponseModel> getYourFeedPage(String? offset) async {
    final url = _urlBuilder.yourFeedUrl(offset);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    final postListPage = PostPageResponseModel.fromJson(jsonObject);
    return postListPage;
  }

  Future<PostPageResponseModel> getProfileFeedPage(String profileSlug, [String? offset]) async {
    final url = _urlBuilder.profileFeedUrl(profileSlug, offset);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    final postListPage = PostPageResponseModel.fromJson(jsonObject);
    return postListPage;
  }

  Future<PostPageResponseModel> getSubwikiFeedPage(String subwikiSlug, [String? offset]) async {
    final url = _urlBuilder.subwikiFeedUrl(subwikiSlug, offset);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    final postListPage = PostPageResponseModel.fromJson(jsonObject);
    return postListPage;
  }

  Future<PostPageResponseModel> getAllProfilesFeedPage(String? offset) async {
    final url = _urlBuilder.allProfilesFeedUrl(offset);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    final postListPage = PostPageResponseModel.fromJson(jsonObject);
    return postListPage;
  }

  Future<PostPageResponseModel> getRemovedFeedPage(String? offset) async {
    final url = _urlBuilder.removedFeedUrl(offset);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    final postListPage = PostPageResponseModel.fromJson(jsonObject);
    return postListPage;
  }

  Future<CommentPageResponseModel> getCommentPage(
      String postId, [String? offset]) async {
    final url = _urlBuilder.postCommentsUrl(postId);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    final commentListPage = CommentPageResponseModel.fromJson(jsonObject);
    return commentListPage;
  }

  Future<PostDetailsResponseModel?> getPost(String postId) async {
    final url = _urlBuilder.postDetailsUrl(postId);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    try{
      final post = PostDetailsResponseModel.fromJson(jsonObject);
      return post;
    } catch (e) {
      log('$e');
      return null;
    }
  }

  Future<List<AppUserVoteResponseModel>> getAppUserVotes() async {
    final url = _urlBuilder.appUserVotesUrl();
    final response = await _dio.get(url);

    final jsonObject = response.data as List<dynamic>;

    final items = jsonObject
        .map((e) => AppUserVoteResponseModel.fromJson(e as Map<String, dynamic>)).toList();
    return items;
  }

  Future<void> castUserVote({
    required bool isUp,
    required String sk,
    required String pk,
    required String slug,
  }) async {

    final url = _urlBuilder.castUserVote();
    final parent = {
      'sk': sk,
      'pk': pk,
      'slug': slug,
    };

    final requestJsonBody = {
      'parent': parent,
      'vote': isUp ? 'up' : 'down',
    };

    await _dio.post(url, data: requestJsonBody);
  }

  Future<void> archiveUserVote({
    required String slug,
    required String userSlug,
  }) async {
    final url = _urlBuilder.archiveUserVote();
    final requestJsonBody = {
      'slug': slug,
      'userslug': userSlug,
    };

    await _dio.put(url, data: requestJsonBody);
  }

  Future<CommentResponseModel> archiveComment({
    required String sk,
    required String pk,
    required String userSlug,
  }) async {
    final url = _urlBuilder.archiveComment();
    final key = {
      'sk': sk,
      'pk': pk,
    };
    final requestJsonBody = {
      'key': key,
      'userslug': userSlug,
    };

    final response = await _dio.put(url, data: requestJsonBody);
    final jsonObject = response.data as Map<String, dynamic>;
    final comment = CommentResponseModel.fromJson(jsonObject);
    return comment;
  }

  Future<CommentResponseModel> restoreComment({
    required String sk,
    required String pk,
  }) async {
    final url = _urlBuilder.restoreComment();
    final requestJsonBody = {
      'key': {
        'sk': sk,
        'pk': pk,
      },
    };

    // print(requestJsonBody);
    final response = await _dio.put(url, data: requestJsonBody);
    final jsonObject = response.data as Map<String, dynamic>;
    final comment = CommentResponseModel.fromJson(jsonObject);
    return comment;
  }

  Future<CommentResponseModel> createComment({
    required String parentSk,
    required String parentPk,
    required String parentSlug,
    required String commentText,
    required String? blurLabel,
  }) async {
    final url = _urlBuilder.createComment();
    final requestJsonBody = {
      'parent': {
        'sk': parentSk,
        'pk': parentPk,
        'slug': parentSlug,
      },
      'commentText': commentText,
      'blurLabel': blurLabel,
    };

    final response = await _dio.post(url, data: requestJsonBody);
    final jsonObject = response.data as Map<String, dynamic>;
    final comment = CommentResponseModel.fromJson(jsonObject);
    return comment;
  }

  Future<void> signOut() async {
    final url = _urlBuilder.signOutUrl();
    await _dio.delete(url);
  }

  Future<void> archivePost({
    required String sk,
    required String pk,
    required String userSlug,
  }) async {
    final url = _urlBuilder.archivePost();
    final key = {
      'sk': sk,
      'pk': pk,
    };
    final requestJsonBody = {
      'key': key,
      'userslug': userSlug,
    };

    await _dio.put(url, data: requestJsonBody);
  }

  Future<PostDetailsResponseModel> restorePost({
    required String sk,
    required String pk,
  }) async {
    final url = _urlBuilder.restorePost();
    final key = {
      'sk': sk,
      'pk': pk,
    };
    final requestJsonBody = {
      'key': key,
    };

    final response = await _dio.put(url, data: requestJsonBody);
    final jsonObject = response.data as Map<String, dynamic>;
    return PostDetailsResponseModel.fromJson(jsonObject);
  }

  Future<GetReactionResponseModel> getReaction(String sk) async {
    final url = _urlBuilder.getReaction(sk);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    final reaction = GetReactionResponseModel.fromJson(jsonObject);
    return reaction;
  }

  Future<ReactToResponseModel> castReaction({
    required String reaction,
    required String entity,
    required String pk,
    required String sk,
    required String slug,
  }) async {
    final requestJsonBody = {
      'parent': {
        'entity': entity,
        'sk': sk,
        'pk': pk,
        'slug': slug,
      },
      'reaction': reaction,
    };

    final url = _urlBuilder.castReaction();
    final response = await _dio.post(url, data: requestJsonBody);
    final jsonObject = response.data as Map<String, dynamic>;
    final reactionResponse = ReactToResponseModel.fromJson(jsonObject);
    return reactionResponse;
  }

  Future<TrustObjectResponseModel?> getTrustObjectBySlug(String userSlug) async {
    final url = _urlBuilder.getTrust(userSlug);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    if(jsonObject['exists']==false){
      return null;
    } else {
      return TrustObjectResponseModel.fromJson(jsonObject);
    }
  }

  Future<TrustObjectResponseModel> createTrustObject({
    required String parentSk,
    required String parentSlug,
    required int trustLevel,
  }) async {
    final requestJsonBody = {
      'parent':{
        'sk': parentSk, //"userprofile#qizil"
      },
      'parentSlug': parentSlug,
      'trustLevel': trustLevel,
    };

    final url = _urlBuilder.castTrust();
    final response = await _dio.post(url, data: requestJsonBody);
    final jsonObject = response.data as Map<String, dynamic>;
    return TrustObjectResponseModel.fromJson(jsonObject);
  }

  Future<void> updateTrustObject({
    required String keyPk,
    required String keySk,
    required int trustLevel,
  }) async {
    final requestJsonBody = {
      'key':{
        'pk': keyPk, //reltrust#userprofile#born-tolive
        'sk': keySk, //truster#blue-sphere
      },
      'trustLevel': trustLevel,
    };

    final url = _urlBuilder.castTrust();
    await _dio.put(url, data: requestJsonBody);
  }

  Future<SpiderDataResponseModel> getSpiderData(String targetUrl) async {
    final url = _urlBuilder.getSpiderUrl(targetUrl);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    return SpiderDataResponseModel.fromJson(jsonObject);
  }

  Future<PostDetailsResponseModel> createPost({
    required String parentSk,
    required String parentPk,
    required String postText,
    required bool collaborative,
    required String cardUrl,
    required String? blurLabel,
  }) async {
    final url = _urlBuilder.createPost();
    final requestJsonBody = {
      'parent': {
        'sk': parentSk,
        'pk': parentPk,
      },
      'cardUrl': cardUrl,
      'collaborative': collaborative,
      'postText': postText,
      'blurLabel': blurLabel,
    };

    final response = await _dio.post(url, data: requestJsonBody);
    final jsonObject = response.data as Map<String, dynamic>;

    final post = PostDetailsResponseModel.fromJson(jsonObject);
    return post;
  }

  Future<PostDetailsResponseModel> updatePost({
    required String keySk,
    required String keyPk,
    required String keySlug,
    required String postText,
    required bool collaborative,
    required String cardUrl,
    required String? blurLabel,
  }) async {
    final url = _urlBuilder.updatePost();
    final requestJsonBody = {
      'key': {
        'sk': keySk,
        'pk': keyPk,
        'slug': keySlug,
      },
      'cardUrl': cardUrl,
      'collaborative': collaborative,
      'postText': postText,
      'blurLabel': blurLabel,
    };
    final response = await _dio.put(url, data: requestJsonBody);
    final jsonObject = response.data as Map<String, dynamic>;
    final post = PostDetailsResponseModel.fromJson(jsonObject);
    return post;

  }

  Future<CommentResponseModel> updateComment({
    required String keySk,
    required String keyPk,
    required String keySlug,
    required String commentText,
    required String? blurLabel,
  }) async {
    final url = _urlBuilder.updateComment();
    final requestJsonBody = {
      'key': {
        'sk': keySk,
        'pk': keyPk,
        'slug': keySlug,
      },
      'commentText': commentText,
      'blurLabel': blurLabel,
    };

    final response = await _dio.put(url, data: requestJsonBody);
    final jsonObject = response.data as Map<String, dynamic>;
    final comment = CommentResponseModel.fromJson(jsonObject);
    return comment;
  }

  Future<String> uploadImage({
    required Uint8List file,
    required String fileName,
    required String contentType,
  }) async {
    final signedUrlRequest = _urlBuilder.uploadsSignedUrl();
    final requestJsonBody = {
      'filePath': fileName,
      'contentType': contentType,
    };

    final signedUrlResponse = await _dio.post(signedUrlRequest, data: requestJsonBody);
    final jsonObject = signedUrlResponse.data as Map<String, dynamic>;
    final imageUrl = _urlBuilder.uploadsContent(jsonObject['s3key'] as String);

    try{
      await http.put(
        Uri.parse(jsonObject['signedurl'] as String),
        headers: {
          'Content-Type': contentType,
          'Accept': "*/*",
          'Connection': 'keep-alive',
          'Content-Length': file.length.toString(),
        },
        body: file,
      );
      return imageUrl;
    } catch(e){
      log('error trying to upload image to server: $e');
      rethrow;
    }
  }

  Future<SubwikiPageResponseModel> getSubwikis([String? offset]) async {
    final url = _urlBuilder.getSubwikis(offset);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    final subwikiListPage = SubwikiPageResponseModel.fromJson(jsonObject);
    return subwikiListPage;
  }

  Future<void> movePostToUserProfile({
    required String keyPk,
    required String keySk,
  }) async {
    final url = _urlBuilder.movePostToUserProfile();
    final requestJsonBody = {
      'key': {
        'pk': keyPk,
        'sk': keySk,
      },
    };

    await _dio.put(url, data: requestJsonBody);
  }

  Future<void> updatePostBranch({
    required String keyPk,
    required String keySk,
    required String destinationBranchSlug,
    required String postId,
  }) async {
    final url = _urlBuilder.updatePostBranch();
    final requestJsonBody = {
      'key': {
        'sk': keySk,
        'pk': keyPk,
      },
      'destinationBranchSlug': destinationBranchSlug,
      'postID': postId,
    };

    await _dio.put(url, data: requestJsonBody);
  }

  Future<NotificationPageResponseModel> getNotifications(String? offset) async {
    final url = _urlBuilder.getNotifications(offset);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    final notificationsPage = NotificationPageResponseModel.fromJson(jsonObject);
    return notificationsPage;
  }

  Future<UserprofileResponseModel> getUserprofile(String slug) async {
    final url = _urlBuilder.getUserprofile(slug);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    final userprofile = UserprofileResponseModel.fromJson(jsonObject);
    return userprofile;
  }

  Future<bool> checkIsFollowing(String slug, {required bool isUserprofile}) async {
    final url = isUserprofile
        ? _urlBuilder.checkIsFollowingUser(slug)
        : _urlBuilder.checkIsFollowingBranch(slug);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    if(jsonObject['exists']!=null && jsonObject['exists'] == false){
      return false;
    } else {
      return true;
    }
  }

  Future<SubwikiDetailsResponseModel> getBranch(String slug) async {
    final url = _urlBuilder.getBranch(slug);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    final branch = SubwikiDetailsResponseModel.fromJson(jsonObject);
    return branch;
  }

  Future<void> createSubscription(String slug, {required bool isUserprofile}) async {
    final url = _urlBuilder.createSubscription();
    final type = isUserprofile ? 'userprofile': 'subwiki';
    final requestJsonBody = {
      'parent': {
        'sk': '$type#$slug',
        'pk': '$type#$slug',
      },
      'followType': type,
      'parentSlug': slug,
      'preferences': {'notification':true,'emailDigest':true,'emailNew':false},
    };

    await _dio.post(url, data: requestJsonBody);
  }

  Future<void> deleteSubscription(String slug, {required bool isUserprofile}) async {
    final url = isUserprofile
        ? _urlBuilder.deleteUserSubscription(slug)
        : _urlBuilder.deleteBranchSubscription(slug);
    await _dio.delete(url);
  }

  Future<ChangePageResponseModel> getChanges(String date) async {
    final url = _urlBuilder.getChanges(date);
    final response = await _dio.get(url);
    final jsonObject = response.data as Map<String, dynamic>;
    final changes = ChangePageResponseModel.fromJson(jsonObject);
    return changes;
  }

  void cancel() {
    _authCredentialsBehaviorSubject.close();
  }
}
