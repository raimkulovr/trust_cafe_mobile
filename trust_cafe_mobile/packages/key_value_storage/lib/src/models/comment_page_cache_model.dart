import 'package:hive/hive.dart';

import 'comment_cache_model.dart';

part 'comment_page_cache_model.g.dart';

@HiveType(typeId: 15)
class CommentPageCacheModel{
  const CommentPageCacheModel({
    required this.commentList,
    this.pageKey,
    this.nextPageKey,
  });

  @HiveField(0)
  final List<CommentCacheModel> commentList;
  @HiveField(1)
  final String? pageKey;
  @HiveField(2)
  final String? nextPageKey;

}