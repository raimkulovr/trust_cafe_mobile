part of 'branch_cubit.dart';

enum BranchStateErrors {
  load,
  follow,
  unfollow,
}

class BranchState extends Equatable {
  const BranchState({
    this.branch,
    this.isFollowing = false,
    this.isLoadingBranch = true,
    this.isLoadingSubscriptionData = false,
    this.error,
  });

  final Subwiki? branch;
  final bool isFollowing;
  final bool isLoadingBranch;
  final bool isLoadingSubscriptionData;
  final BranchStateErrors? error;

  @override
  List<Object?> get props => [
    branch,
    isFollowing,
    isLoadingBranch,
    isLoadingSubscriptionData,
    error,
  ];

  BranchState copyWith({
    Wrapped<Subwiki?>? branch,
    bool? isFollowing,
    bool? isLoadingBranch,
    bool? isLoadingSubscriptionData,
    Wrapped<BranchStateErrors?>? error,
  }) {
    return BranchState(
      branch: branch!=null ? branch.value : this.branch,
      isFollowing: isFollowing ?? this.isFollowing,
      isLoadingBranch: isLoadingBranch ?? this.isLoadingBranch,
      isLoadingSubscriptionData:
          isLoadingSubscriptionData ?? this.isLoadingSubscriptionData,
      error: error!=null ? error.value : this.error,
    );
  }
}

