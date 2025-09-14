import 'dart:developer';

import 'package:hive_ce/hive.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

import '../hive/hive_adapters.dart';

class KeyValueStorage {
  static const _appUserBoxKey = 'app-user';
  static const _apiChannelBoxKey = 'api-channel';
  static const _usersBoxKey = 'users';
  static const _forYouFeedPagesBoxKey = 'for-you-feed-pages-v2';
  static const _yourFeedPagesBoxKey = 'your-feed-pages-v2';
  static const _profileFeedPagesBoxKey = 'profile-feed-pages-v2';
  static const _branchFeedPagesBoxKey = 'branch-feed-pages-v2';
  static const _allProfilesFeedPagesBoxKey = 'all-profiles-feed-pages-v2';
  static const _removedFeedPagesBoxKey = 'removed-feed-pages-v2';
  static const _commentPagesBoxKey = 'comment-pages';
  static const _appUserVotesBoxKey = 'app-user-votes';
  static const _translationsBoxKey = 'translations';
  static const _translationTargetBoxKey = 'translation-target';
  static const _appThemeModeBoxBoxKey = 'app-theme-mode';
  static const _reactionsBoxKey = 'reactions';
  static const _trustObjectsBoxKey = 'trust-objects';
  static const _spiderObjectsBoxKey = 'spider-objects';
  static const _subwikisBoxKey = 'subwikis';
  static const _ignoredListBoxKey = 'ignored-list';
  static const _imageSizeThresholdBoxKey = 'image-size-threshold';
  static const _draftsBoxKey = 'drafts';
  static const _allPostsBoxKey = 'all-posts';

  KeyValueStorage({
    @visibleForTesting HiveInterface? hive,
  }) : _hive = hive ?? Hive {
    try {
      _hive
        ..registerAdapter(AppUserCacheModelAdapter())
        ..registerAdapter(PostCacheModelAdapter())
        ..registerAdapter(AuthorCacheModelAdapter())
        ..registerAdapter(PostStatisticsCacheModelAdapter())
        ..registerAdapter(PostDataCacheModelAdapter())
        ..registerAdapter(SubwikiPostOriginCacheModelAdapter())
        ..registerAdapter(MainTrunkPostOriginCacheModelAdapter())
        ..registerAdapter(UserProfilePostOriginCacheModelAdapter())
        ..registerAdapter(PostPageCacheModelAdapter())
        ..registerAdapter(CommentCacheModelAdapter())
        ..registerAdapter(CommentStatisticsCacheModelAdapter())
        ..registerAdapter(CommentDataCacheModelAdapter())
        ..registerAdapter(CommentOriginCacheModelAdapter())
        ..registerAdapter(CommentDestinationCacheModelAdapter())
        ..registerAdapter(CommentPageCacheModelAdapter())
        ..registerAdapter(UserVoteCacheModelAdapter())
        ..registerAdapter(TranslationCacheModelAdapter())
        ..registerAdapter(ReactionsCacheModelAdapter())
        ..registerAdapter(TrustObjectCacheModelAdapter())
        ..registerAdapter(SpiderUrlDataCacheModelAdapter())
        ..registerAdapter(SpiderFetchDataCacheModelAdapter())
        ..registerAdapter(SpiderOembedDataCacheModelAdapter())
        ..registerAdapter(SubwikiStatisticsCacheModelAdapter())
        ..registerAdapter(SubwikiCacheModelAdapter())
        ..registerAdapter(SubwikiListCacheModelAdapter())
      ;
    } catch (e) {
      log('KeyValueStorage init error: $e');
      throw Exception(
          'You shouldn\'t have more than one [KeyValueStorage] instance in your '
          'project');
    }
  }

  final HiveInterface _hive;

  Future<Box<AppUserCacheModel>> get appUserBox =>
      _openHiveBox<AppUserCacheModel>(
        _appUserBoxKey,
        isTemporary: false,
      );

  Future<Box<bool>> get apiChannelBox =>
      _openHiveBox<bool>(
        _apiChannelBoxKey,
        isTemporary: false,
      );

  Future<Box<String>> get translationTargetBox =>
      _openHiveBox<String>(
        _translationTargetBoxKey,
        isTemporary: false,
      );

  Future<Box<String>> get appThemeModeBox =>
      _openHiveBox<String>(
        _appThemeModeBoxBoxKey,
        isTemporary: false,
      );

  Future<Box<double?>> get imageSizeThresholdBox =>
      _openHiveBox<double?>(
        _imageSizeThresholdBoxKey,
        isTemporary: false,
      );

  Future<Box<List<String>>> get ignoredListBox =>
      _openHiveBox<List<String>>(
          _ignoredListBoxKey,
          isTemporary: false
      );

  Future<Box<String>> get draftsBox =>
      _openHiveBox<String>(
          _draftsBoxKey,
          isTemporary: false
      );

  Future<Box<AuthorCacheModel>> get usersBox =>
      _openHiveBox<AuthorCacheModel>(
          _usersBoxKey,
          isTemporary: true
      );

  Future<Box<PostPageCacheModel>> get forYouFeedPagesBox =>
      _openHiveBox<PostPageCacheModel>(
        _forYouFeedPagesBoxKey,
        isTemporary: true,
      );

  Future<Box<PostPageCacheModel>> get yourFeedPagesBox =>
      _openHiveBox<PostPageCacheModel>(
        _yourFeedPagesBoxKey,
        isTemporary: true,
      );

  Future<Box<PostPageCacheModel>> get profileFeedPagesBox =>
      _openHiveBox<PostPageCacheModel>(
        _profileFeedPagesBoxKey,
        isTemporary: true,
      );

  Future<Box<PostPageCacheModel>> get branchFeedPagesBox =>
      _openHiveBox<PostPageCacheModel>(
        _branchFeedPagesBoxKey,
        isTemporary: true,
      );

  Future<Box<PostPageCacheModel>> get allProfilesFeedPagesBox =>
      _openHiveBox<PostPageCacheModel>(
        _allProfilesFeedPagesBoxKey,
        isTemporary: true,
      );

  Future<Box<PostPageCacheModel>> get removedFeedPagesBox =>
      _openHiveBox<PostPageCacheModel>(
        _removedFeedPagesBoxKey,
        isTemporary: true,
      );

  Future<Box<CommentPageCacheModel>> get commentPagesBox =>
      _openHiveBox<CommentPageCacheModel>(
          _commentPagesBoxKey,
          isTemporary: true
      );

  Future<Box<UserVoteCacheModel>> get appUserVotesBox =>
      _openHiveBox<UserVoteCacheModel>(
        _appUserVotesBoxKey,
        isTemporary: true,
      );

  Future<Box<TranslationCacheModel>> get translationsBox =>
      _openHiveBox<TranslationCacheModel>(
        _translationsBoxKey,
        isTemporary: true,
      );

  Future<Box<String>> get reactionsBox =>
      _openHiveBox<String>(
        _reactionsBoxKey,
        isTemporary: true,
      );

  Future<Box<TrustObjectCacheModel>> get trustObjectsBox =>
      _openHiveBox<TrustObjectCacheModel>(
        _trustObjectsBoxKey,
        isTemporary: true,
      );

  Future<Box<SpiderUrlDataCacheModel>> get spiderObjectsBox =>
      _openHiveBox<SpiderUrlDataCacheModel>(
        _spiderObjectsBoxKey,
        isTemporary: true,
      );

  Future<Box<SubwikiListCacheModel>> get subwikisBox =>
      _openHiveBox<SubwikiListCacheModel>(
        _subwikisBoxKey,
        isTemporary: true,
      );

  Future<Box<PostCacheModel>> get allPostsBox =>
      _openHiveBox<PostCacheModel>(
        _allPostsBoxKey,
        isTemporary: true,
      );

  Future<Box<T>> _openHiveBox<T>(
    String boxKey, {
    required bool isTemporary,
  }) async {
    if (_hive.isBoxOpen(boxKey)) {
      return _hive.box(boxKey);
    } else {
      final directory = await (isTemporary
          ? getTemporaryDirectory()
          : getApplicationDocumentsDirectory());
      return _hive.openBox<T>(
        boxKey,
        path: directory.path,
      );
    }
  }

  Future<void> clearTemporaryStorage() async {
    await usersBox.then((box) => box.clear());
    await forYouFeedPagesBox.then((box) => box.clear());
    await commentPagesBox.then((box) => box.clear());
    await appUserVotesBox.then((box) => box.clear());
    await translationsBox.then((box) => box.clear());
    await reactionsBox.then((box) => box.clear());
    await trustObjectsBox.then((box) => box.clear());
    await spiderObjectsBox.then((box) => box.clear());
    await subwikisBox.then((box) => box.clear());
    await yourFeedPagesBox.then((box) => box.clear());
    await profileFeedPagesBox.then((box) => box.clear());
    await branchFeedPagesBox.then((box) => box.clear());
    await allProfilesFeedPagesBox.then((box) => box.clear());
    await removedFeedPagesBox.then((box) => box.clear());
    await allPostsBox.then((box) => box.clear());
  }
}
