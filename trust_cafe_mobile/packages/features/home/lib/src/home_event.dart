part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomePostRegistered extends HomeEvent {
  const HomePostRegistered();
}

class HomeUsernameObtained extends HomeEvent {
  const HomeUsernameObtained({this.authenticatedUser});

  final AppUser? authenticatedUser;
}

class HomePostCreated extends HomeEvent {
  const HomePostCreated({
    required this.postText,
    required this.collaborative,
    required this.cardUrl,
    required this.parentSk,
    required this.parentPk,
    required this.blurLabel,
  });

  final String postText;
  final bool collaborative;
  final String cardUrl;
  final String parentSk;
  final String parentPk;
  final String? blurLabel;

  @override
  List<Object?> get props =>
      [postText, collaborative, cardUrl, parentSk, parentPk, blurLabel];

}

class HomeNotificationsRefreshed extends HomeEvent{
  const HomeNotificationsRefreshed({this.silent = false});

  final bool silent;
}
