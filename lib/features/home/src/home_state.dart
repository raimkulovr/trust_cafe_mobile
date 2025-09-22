part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.newPost,
    this.createNewPostError,
    this.creatingNewPost = false,
    this.notifications = const [],
    this.isReloadingNotifications = false,
});

  final Post? newPost;
  final dynamic createNewPostError;
  final bool creatingNewPost;
  final List<Notification> notifications;
  final bool isReloadingNotifications;
  int get unreadNotifications => notifications.where((e) => e.item.read==false,).length;

  HomeState copyWithNewPostError(dynamic createNewPostError) =>
      HomeState(
        newPost: null,
        createNewPostError: createNewPostError,
        creatingNewPost: false,
        notifications: notifications,
        isReloadingNotifications: isReloadingNotifications,
      );

  @override
  List<Object?> get props => [
    newPost,
    createNewPostError,
    creatingNewPost,
    notifications,
    isReloadingNotifications,
  ];

  HomeState copyWith({
    Wrapped<Post?>? newPost,
    Wrapped<dynamic>? createNewPostError,
    bool? creatingNewPost,
    List<Notification>? notifications,
    bool? isReloadingNotifications,
  }) {
    return HomeState(
      newPost: newPost!=null ? newPost.value : this.newPost,
      createNewPostError: createNewPostError !=null ? createNewPostError.value : this.createNewPostError,
      creatingNewPost: creatingNewPost ?? this.creatingNewPost,
      notifications: notifications ?? this.notifications,
      isReloadingNotifications: isReloadingNotifications ?? this.isReloadingNotifications,
    );
  }

  @override
  String toString() {
    return 'HomeState{newPost: $newPost, createNewPostError: $createNewPostError, creatingNewPost: $creatingNewPost, notifications: ${notifications.length}, isReloadingNotifications: $isReloadingNotifications}';
  }
}