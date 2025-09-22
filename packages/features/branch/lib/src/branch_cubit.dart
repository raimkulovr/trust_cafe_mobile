import 'package:bloc/bloc.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

part 'branch_state.dart';

class BranchCubit extends Cubit<BranchState> {
  BranchCubit({
    required ContentRepository contentRepository,
    required this.slug,
    required this.appUser,
  }) :  _contentRepository = contentRepository,
        super(const BranchState())
  {
    _getBranch();
    if(appUser.isNotGuest) _checkIsFollowing();
  }
  final ContentRepository _contentRepository;
  final String slug;
  final AppUser appUser;

  void _getBranch() async {
    try{
      final branch = await _contentRepository.getBranch(slug);
      emit(state.copyWith(branch: Wrapped.value(branch), isLoadingBranch: false));
    } catch (e) {
      emit(state.copyWith(error: const Wrapped.value(BranchStateErrors.load), isLoadingBranch: false));
      _resetError();
    }
  }

  void _checkIsFollowing() async {
    emit(state.copyWith(isLoadingSubscriptionData: true));
    final isFollowing = await _contentRepository.checkIsFollowing(slug, isUserprofile: false);
    emit(state.copyWith(isFollowing: isFollowing, isLoadingSubscriptionData: false));
  }

  void _resetError() {
    emit(state.copyWith(error: const Wrapped.value(null)));
  }

  void refresh() async {
    _resetError();
    emit(state.copyWith(isLoadingBranch: true));
    _getBranch();
  }

  void follow(){
    final initialIsFollowing = state.isFollowing;
    emit(state.copyWith(isFollowing: true));

    try {
      _contentRepository.createSubscription(slug, isUserprofile: false);
    } catch (e) {
      emit(state.copyWith(error: const Wrapped.value(BranchStateErrors.follow), isFollowing: initialIsFollowing));
      _resetError();
    }
  }

  void unfollow(){
    final initialIsFollowing = state.isFollowing;
    emit(state.copyWith(isFollowing: false));

    try {
      _contentRepository.deleteSubscription(slug, isUserprofile: false);
    } catch (e) {
      emit(state.copyWith(error: const Wrapped.value(BranchStateErrors.unfollow), isFollowing: initialIsFollowing));
      _resetError();
    }
  }

}
