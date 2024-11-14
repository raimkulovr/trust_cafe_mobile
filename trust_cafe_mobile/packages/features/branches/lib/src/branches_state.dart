part of 'branches_cubit.dart';

final class BranchesState extends Equatable {
  const BranchesState({
    required this.isLoading,
    required this.subwikiList,
    this.lastUpdated,
    this.selectedItem,
    this.error,
  });

  final bool isLoading;
  final List<Subwiki> subwikiList;
  final DateTime? lastUpdated;
  final Subwiki? selectedItem;
  final dynamic error;

  @override
  List<Object?> get props => [
    isLoading,
    subwikiList,
    lastUpdated,
    selectedItem,
    error,
  ];

  BranchesState copyWith({
    bool? isLoading,
    List<Subwiki>? subwikiList,
    Wrapped<DateTime?>? lastUpdated,
    Wrapped<Subwiki?>? selectedItem,
    Wrapped<dynamic>? error,
  }) {
    return BranchesState(
      isLoading: isLoading ?? this.isLoading,
      subwikiList: subwikiList ?? this.subwikiList,
      lastUpdated: lastUpdated != null ? lastUpdated.value : this.lastUpdated,
      selectedItem: selectedItem != null ? selectedItem.value : this.selectedItem,
      error: error != null ? error.value : this.error,
    );
  }

  @override
  String toString() {
    return 'BranchesState{isLoading: $isLoading, subwikiList: ${subwikiList.length}, lastUpdated: $lastUpdated, selectedItem: $selectedItem, error: $error}';
  }
}
