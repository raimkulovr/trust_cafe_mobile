import 'package:component_library/typedefs.dart';
import 'package:flutter/material.dart';

class CommentCallbackProvider extends InheritedWidget {
  final GetAppUserCallback getAppUser;
  final OnCommentRepliedCallback onCommentReplied;
  final VoidCallback? onParentAuthorPressed;


  const CommentCallbackProvider({super.key,
    required this.getAppUser,
    required this.onCommentReplied,
    required this.onParentAuthorPressed,
    required super.child,
  });

  static CommentCallbackProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CommentCallbackProvider>();
  }

  static CommentCallbackProvider of(BuildContext context) {
    final CommentCallbackProvider? result = maybeOf(context);
    assert(result != null, 'No CommentCallbackProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(CommentCallbackProvider oldWidget) {
    return false;
  }
}