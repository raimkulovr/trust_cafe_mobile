import 'package:hive_ce/hive.dart';
import 'package:key_value_storage/src/models/app_user_cache_model.dart';
import 'package:key_value_storage/src/models/author_cache_model.dart';
import 'package:key_value_storage/src/models/comment_cache_model.dart';
import 'package:key_value_storage/src/models/comment_page_cache_model.dart';
import 'package:key_value_storage/src/models/post_cache_model.dart';
import 'package:key_value_storage/src/models/post_page_cache_model.dart';
import 'package:key_value_storage/src/models/reactions_cache_model.dart';
import 'package:key_value_storage/src/models/spider/spider_fetch_data_cache_model.dart';
import 'package:key_value_storage/src/models/spider/spider_oembed_data_cache_model.dart';
import 'package:key_value_storage/src/models/spider/spider_url_data_cache_model.dart';
import 'package:key_value_storage/src/models/subwiki_cache_model.dart';
import 'package:key_value_storage/src/models/subwiki_list_cache_model.dart';
import 'package:key_value_storage/src/models/translation_cache_model.dart';
import 'package:key_value_storage/src/models/trust_object_cache_model.dart';

@GenerateAdapters([
  AdapterSpec<AppUserCacheModel>(),
  AdapterSpec<PostCacheModel>(),
  AdapterSpec<AuthorCacheModel>(),
  AdapterSpec<PostStatisticsCacheModel>(),
  AdapterSpec<PostDataCacheModel>(),
  AdapterSpec<SubwikiPostOriginCacheModel>(),
  AdapterSpec<MainTrunkPostOriginCacheModel>(),
  AdapterSpec<UserProfilePostOriginCacheModel>(),
  AdapterSpec<PostPageCacheModel>(),
  AdapterSpec<CommentCacheModel>(),
  AdapterSpec<CommentStatisticsCacheModel>(),
  AdapterSpec<CommentDestinationCacheModel>(),
  AdapterSpec<CommentDataCacheModel>(),
  AdapterSpec<CommentOriginCacheModel>(),
  AdapterSpec<CommentPageCacheModel>(),
  AdapterSpec<UserVoteCacheModel>(),
  AdapterSpec<TranslationCacheModel>(),
  AdapterSpec<ReactionsCacheModel>(),
  AdapterSpec<TrustObjectCacheModel>(),
  AdapterSpec<SpiderUrlDataCacheModel>(),
  AdapterSpec<SpiderFetchDataCacheModel>(),
  AdapterSpec<SpiderOembedDataCacheModel>(),
  AdapterSpec<SubwikiListCacheModel>(),
  AdapterSpec<SubwikiCacheModel>(),
  AdapterSpec<SubwikiStatisticsCacheModel>(),
])
part 'hive_adapters.g.dart';
