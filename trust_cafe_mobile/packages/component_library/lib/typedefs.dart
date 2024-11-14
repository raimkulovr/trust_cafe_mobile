import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

typedef GetAppUserCallback = AppUser Function();
typedef OnPostRemovedCallback = void Function({required String sk, required String pk, required bool archive});
typedef OnPostUpdatedCallback = void Function(Post updatedPost);
typedef OnAuthenticationRequestedCallback = void Function(BuildContext context);
typedef OnCommentsRequestedCallback = void Function();
typedef OnCommentArchivedRestoredCallback = void Function(String sk, String pk);
typedef OnCommentUpdatedCallback = void Function(Comment updatedComment);
typedef OnCommentRepliedCallback = void Function({required String sk, required String pk, required String slug, required String fullName});
typedef OnPostOpenedCallback = void Function(String postId);
