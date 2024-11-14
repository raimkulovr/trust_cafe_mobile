import 'dart:async';
import 'dart:developer';
import 'package:comment/comment.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';

import 'package:comments/src/comments_bloc.dart';
import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:user_repository/user_repository.dart';
import 'package:text_editor/text_editor.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({
    required this.contentRepository,
    required this.userRepository,
    required this.postData,
    this.child,
    this.scrollToSlug,
    super.key,
  });

  final ContentRepository contentRepository;
  final UserRepository userRepository;
  final CommentsPostData postData;
  final Widget? child;
  //couldn't figure it out. will try again later
  final String? scrollToSlug;

  static void showComments({
    required BuildContext context,
    required Post post,
    required Color backgroundColor,
    required ContentRepository contentRepository,
    required UserRepository userRepository,
    String? scrollToSlug,
  }) => showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    backgroundColor: backgroundColor,
    useSafeArea: true,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      return TcmBottomSheet(
        child: CommentsScreen(
          contentRepository: contentRepository,
          userRepository: userRepository,
          postData: CommentsPostData.fromPost(post),
          scrollToSlug: scrollToSlug,
        ),
      );
    },
  );

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late final StreamController onRefreshStreamController;

  @override
  void initState() {
    onRefreshStreamController = StreamController.broadcast();
    super.initState();
  }

  @override
  void dispose() {
    onRefreshStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: widget.userRepository,),
        RepositoryProvider.value(value: widget.contentRepository,),
      ],
      child: BlocProvider<CommentsBloc>(
          lazy: false,
          create: (context) => CommentsBloc(
              contentRepository: widget.contentRepository,
              userRepository: widget.userRepository,
              onRefreshStreamController: onRefreshStreamController,
              postData: widget.postData,
          ),
          child: widget.child ?? CommentsView(scrollToSlug: widget.scrollToSlug,)),
    );
  }
}

class CommentsView extends StatefulWidget {
  const CommentsView({this.scrollToSlug, super.key});
  final String? scrollToSlug;

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  bool scrolledToSlug = false;
  ContentRepository get contentRepository => RepositoryProvider.of<ContentRepository>(context);
  UserRepository get userRepository => RepositoryProvider.of<UserRepository>(context);
  CommentsBloc get _bloc => context.read<CommentsBloc>();

  late final AnchorScrollController _scrollController;
  late final PagingController<String?, Comment> _pagingController;
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  final Set<String> _utilUsedKeys = <String>{};
  ReplyData? replyData;

  void setReplyData({
    required String sk,
    required String pk,
    required String slug,
    required String fullName,
  }){
    _focusNode.requestFocus();
    setState(() {
      replyData = ReplyData(sk: sk, pk: pk, slug: slug, fullName: fullName);
    });
  }

  void resetReplyData(){
    _focusNode.unfocus();
    setState(() {
      replyData = null;
    });
  }

  @override
  void initState() {
    _scrollController = AnchorScrollController();
    _focusNode = FocusNode();
    _textController = TextEditingController();
    _pagingController = PagingController(firstPageKey: null);
    _pagingController.value = _bloc.state.toPagingState();
    _pagingController.addPageRequestListener((pageKey) {
      final isSubsequentPage = pageKey!=null;
      if (isSubsequentPage && !_utilUsedKeys.contains(pageKey)) {
        _bloc.add(
          CommentsNextPageRequested(
            pageKey: pageKey,
          ),
        );
        _utilUsedKeys.add(pageKey);
      }
    });

    super.initState();
  }

  //TODO: l10n
  String _errorMessage(CommentsStateErrors error) => switch(error){
    CommentsStateErrors.refresh => 'Failed to refresh',
    CommentsStateErrors.newComment => 'Failed to create a new comment',
  };

  void _scrollTo(String slug) {
    _scrollController.scrollToIndex(index: _pagingController.itemList!.indexWhere((element) => element.slug == slug,));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return BlocListener<CommentsBloc, CommentsState>(
            listener: (context, state) {
              if(state.error!=null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_errorMessage(state.error!)),
                  ),
                );
              }

              _pagingController.value = state.toPagingState();
            },
            child: RefreshIndicator(
              onRefresh: () {
                setState(() {});
                _utilUsedKeys.clear();
                _bloc.add(const CommentsRefreshed());
                return _bloc.onRefreshStreamController.stream.first;
              },
              child: BlocBuilder<CommentsBloc, CommentsState>(
                  buildWhen: (previous, current) =>
                    previous.authenticatedUser != current.authenticatedUser,
                  builder: (context, state) {
                  return Column(
                    children: [
                      PagingListView<Comment>(
                        scrollController: _scrollController,
                        pagingController: _pagingController,
                        onFirstPageErrorRetry: () => _bloc.add(const CommentsFailedFetchRetried()),
                        itemBuilder: (context,  comment, index) {
                          //TODO: hide comments from blocked and ignored users and branches
                          return state.authenticatedUser!=null
                              ? AnchorItemWrapper(
                                  index: index,
                                  controller: _scrollController,
                                  child: CommentScreen(
                                    key: ValueKey(comment.hashCode),
                                    comment,
                                    appUser: state.authenticatedUser!,
                                    contentRepository: contentRepository,
                                    userRepository: userRepository,
                                    onCommentUpdated: (updatedComment) =>
                                        _bloc.add(CommentsCommentUpdated(updatedComment)),
                                    onCommentReplied: setReplyData,
                                    onParentAuthorPressed: comment.data.comment!=null
                                        ? ()=> _scrollTo(comment.data.comment!.slug)
                                        : null, postId: _bloc.postData.postId,
                                  ),
                                )
                              : const LinearProgressIndicator();
                        },
                      ),
                      state.canComment ? Column(children: [
                        const Divider(),
                        if(replyData!=null) Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      // const SizedBox(width: 8),
                                      const Text('replying to '), //TODO: l10n
                                      Text(replyData.toString(), style: const TextStyle(decoration: TextDecoration.underline),),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                customBorder: const CircleBorder(),
                                onTap: resetReplyData,
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text('x'),
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                              child: TextField(
                                controller: _textController,
                                focusNode: _focusNode,
                                maxLines: 4,
                                minLines: 1,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(hintText: 'What do you think?'),),
                            )),
                            BlocBuilder<CommentsBloc, CommentsState>(
                              buildWhen: (p, c) => p.creatingNewComment != c.creatingNewComment,
                              builder: (context, state) {
                              return state.creatingNewComment
                                  ? const CircularProgressIndicator()
                                  : InkWell(
                                    onLongPress: () async {
                                      final updatedComment = await Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) =>
                                              TextEditorScreen(
                                                contentRepository: contentRepository,
                                                userRepository: userRepository,
                                                destination: TextEditorDestination.comment,
                                                initialText: _textController.text.isEmpty ? null :_textController.text,
                                                isEditing: false,
                                                canChangeIsCollaborative: false,
                                              ),
                                          ));
                                      if (updatedComment is ({String commentText, String? blurLabel}) && updatedComment.commentText.isNotEmpty){
                                        _bloc.add(CommentsCommentCreated(
                                            postId: _bloc.postData.postId,
                                            parentSk: replyData?.sk ?? _bloc.postData.sk,
                                            parentPk: replyData?.pk ?? _bloc.postData.pk,
                                            parentSlug: replyData?.slug ?? _bloc.postData.slug,
                                            commentText: updatedComment.commentText,
                                            simple: false,
                                            blurLabel: updatedComment.blurLabel,
                                        ));
                                        resetReplyData();
                                        _textController.clear();
                                      }
                                    },
                                    child: IconButton(
                                        onPressed: (){
                                          _bloc.add(CommentsCommentCreated(
                                              postId: _bloc.postData.postId,
                                              parentSk: replyData?.sk ?? _bloc.postData.sk,
                                              parentPk: replyData?.pk ?? _bloc.postData.pk,
                                              parentSlug: replyData?.slug ?? _bloc.postData.slug,
                                              commentText: _textController.text,
                                              simple: true,
                                              blurLabel: null,
                                          ));
                                          resetReplyData();
                                          _textController.clear();
                                        },
                                        icon: const Icon(Icons.send)),
                                  );
                              },
                            )
                          ],
                        )
                      ],) : const SizedBox()
                    ],
                  );
                }
              ),
            ),
          );
        }
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }
}

extension on CommentsState {
  PagingState<String?, Comment> toPagingState() {
    return PagingState(
      itemList: commentList,
      nextPageKey: nextPageKey,
      error: pagingError,
    );
  }
}

class ReplyData {
  const ReplyData({
    required this.sk,
    required this.pk,
    required this.slug,
    required this.fullName,
  });

  final String sk;
  final String pk;
  final String slug;
  final String fullName;

  @override
  String toString() => fullName;
}
