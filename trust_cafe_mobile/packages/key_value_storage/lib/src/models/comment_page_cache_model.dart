import 'package:hive_ce/hive.dart';

import 'comment_cache_model.dart';

class CommentPageCacheModel extends HiveObject {
  CommentPageCacheModel({
    required this.commentList,
    this.pageKey,
    this.nextPageKey,
  });

  final List<CommentCacheModel> commentList;
  final String? pageKey;
  final String? nextPageKey;
}
