part of 'userprofile_cubit.dart';

enum UserprofileStateErrors {
  load,
  follow,
  unfollow,
}

class UserprofileState extends Equatable {
  const UserprofileState({
    this.userprofile,
    this.isFollowing = false,
    this.isLoadingProfile = true,
    this.isLoadingSubscriptionData = false,
    this.error,
  });

  final Userprofile? userprofile;
  final bool isFollowing;
  final bool isLoadingProfile;
  final bool isLoadingSubscriptionData;
  final UserprofileStateErrors? error;

  @override
  List<Object?> get props => [
    userprofile,
    isFollowing,
    isLoadingProfile,
    isLoadingSubscriptionData,
    error,
  ];

  UserprofileState copyWith({
    Wrapped<Userprofile?>? userprofile,
    bool? isFollowing,
    bool? isLoadingProfile,
    bool? isLoadingSubscriptionData,
    Wrapped<UserprofileStateErrors?>? error,
  }) {
    return UserprofileState(
      userprofile: userprofile!=null ? userprofile.value : this.userprofile,
      isFollowing: isFollowing ?? this.isFollowing,
      isLoadingProfile: isLoadingProfile ?? this.isLoadingProfile,
      isLoadingSubscriptionData:
          isLoadingSubscriptionData ?? this.isLoadingSubscriptionData,
      error: error!=null ? error.value : this.error,
    );
  }
}

