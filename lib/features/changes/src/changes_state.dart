part of 'changes_cubit.dart';

enum ChangesStateErrors{
  load,
  refresh,
}
class ChangesState extends Equatable {
  const ChangesState({
    required this.date,
    this.changesList = const [],
    this.isLoadingList = true,
    this.error,
  });

  final DateTime date;
  final List<Change> changesList;
  final bool isLoadingList;
  final ChangesStateErrors? error;

  @override
  List<Object?> get props => [
    date,
    changesList,
    isLoadingList,
    error,
  ];

  ChangesState copyWith({
    DateTime? date,
    List<Change>? changesList,
    bool? isLoadingList,
    Wrapped<ChangesStateErrors?>? error,
  }) {
    return ChangesState(
      date: date ?? this.date,
      changesList: changesList ?? this.changesList,
      isLoadingList: isLoadingList ?? this.isLoadingList,
      error: error!=null ? error.value : this.error,
    );
  }

  @override
  String toString() {
    return 'ChangesState{date: $date, changesList: ${changesList.length}, isLoadingList: $isLoadingList, error: $error}';
  }
}

