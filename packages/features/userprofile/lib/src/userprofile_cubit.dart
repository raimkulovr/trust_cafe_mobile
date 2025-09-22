import 'package:bloc/bloc.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

part 'userprofile_state.dart';

class UserprofileCubit extends Cubit<UserprofileState> {
  UserprofileCubit({
    required ContentRepository contentRepository,
    required this.slug,
    required this.appUser,
  }) :  _contentRepository = contentRepository,
        super(const UserprofileState())
  {
    _getUserprofile();
    if(appUser.isNotGuest && appUser.slug!=slug) _checkIsFollowing();
  }
  final ContentRepository _contentRepository;
  final String slug;
  final AppUser appUser;

  void _getUserprofile() async {
    try {
      final userprofile = await _contentRepository.getUserprofile(slug);
      emit(state.copyWith(userprofile: Wrapped.value(userprofile), isLoadingProfile: false));
    } catch (e) {
      emit(state.copyWith(error: const Wrapped.value(UserprofileStateErrors.load), isLoadingProfile: false));
      _resetError();
    }
  }

  void _checkIsFollowing() async {
    emit(state.copyWith(isLoadingSubscriptionData: true));
    final isFollowing = await _contentRepository.checkIsFollowing(slug, isUserprofile: true);
    emit(state.copyWith(isFollowing: isFollowing, isLoadingSubscriptionData: false));
  }

  void _resetError() {
    emit(state.copyWith(error: const Wrapped.value(null)));
  }

  void refresh() async {
    _resetError();
    emit(state.copyWith(isLoadingProfile: true));
    _getUserprofile();
  }

  void follow(){
    final initialIsFollowing = state.isFollowing;
    emit(state.copyWith(isFollowing: true));

    try {
      _contentRepository.createSubscription(slug, isUserprofile: true);
    } catch (e) {
      emit(state.copyWith(error: const Wrapped.value(UserprofileStateErrors.follow), isFollowing: initialIsFollowing));
      _resetError();
    }
  }

  void unfollow(){
    final initialIsFollowing = state.isFollowing;
    emit(state.copyWith(isFollowing: false));

    try {
      _contentRepository.deleteSubscription(slug, isUserprofile: true);
    } catch (e) {
      emit(state.copyWith(error: const Wrapped.value(UserprofileStateErrors.unfollow), isFollowing: initialIsFollowing));
      _resetError();
    }
  }

}
