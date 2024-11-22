import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required ContentRepository contentRepository,
    required UserRepository userRepository,
    required this.appUser,
  }) :  _contentRepository = contentRepository,
        _userRepository = userRepository,
        super(const HomeState())
  {
    _registerEventsHandler();
    add(const HomeStarted());
  }

  final AppUser appUser;
  final UserRepository _userRepository;
  final ContentRepository _contentRepository;

  late final Timer notificationTimer;

  void _registerEventsHandler() {
    on<HomeStarted>(_onHomeStarted);
    on<HomePostCreated>(_onHomePostCreated);
    on<HomePostRegistered>(_onHomePostRegistered);
    on<HomeNotificationsRefreshed>(_onHomeNotificationsRefreshed);
  }

  Future<void> _onHomeStarted(
      HomeStarted event,
      Emitter<HomeState> emit,
  ) async {
    if(appUser.isGuest) return;
    await _contentRepository.getUserVotes();
    final page = await _contentRepository.getNotifications(null);
    emit(state.copyWith(notifications: page.notificationList));
  }

  Future<void> _onHomePostCreated(
    HomePostCreated event,
    Emitter<HomeState> emit,
  ) async {
    if(event.postText.isEmpty || event.postText == '') return;
    final bool isBranchPost = event.parentSk.startsWith('subwiki#');
    try {
      emit(state.copyWith(creatingNewPost: true, createNewPostError: const Wrapped.value(null)));
      final newPost = await _contentRepository.createPost(
        collaborative: event.collaborative,
        parentSk: event.parentSk,
        parentPk: event.parentPk,
        cardUrl: event.cardUrl,
        postText: event.postText,
        blurLabel: event.blurLabel,
      );
      emit(state.copyWith(creatingNewPost: false, newPost: Wrapped.value(newPost), createNewPostError: const Wrapped.value(null)));
    } catch (e) {
      if(isBranchPost){
        try{
          final newPost = await _contentRepository.createPost(
            collaborative: event.collaborative,
            parentSk: 'maintrunk#maintrunk',
            parentPk: 'maintrunk#maintrunk',
            cardUrl: event.cardUrl,
            postText: event.postText,
            blurLabel: event.blurLabel,
          );
          emit(state.copyWith(creatingNewPost: false, newPost: Wrapped.value(newPost), createNewPostError: const Wrapped.value(null)));
        } catch(e){
          emit(state.copyWithNewPostError(e));
        }
      } else {
        emit(state.copyWithNewPostError(e));
      }
    }
  }

  Future<void> _onHomePostRegistered(
    HomePostRegistered event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(newPost: const Wrapped.value(null)));
  }

  Future<void> _onHomeNotificationsRefreshed(
    HomeNotificationsRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    if(appUser.isGuest) return;
    if(!event.silent) emit(state.copyWith(isReloadingNotifications: true));
    final page = await _contentRepository.getNotifications(null);
    emit(state.copyWith(notifications: page.notificationList, isReloadingNotifications: false));
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
