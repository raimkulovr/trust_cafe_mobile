import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart' hide Change;
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

part 'changes_state.dart';

class ChangesCubit extends Cubit<ChangesState> {
  ChangesCubit({
    required ContentRepository contentRepository,
    required this.initialDate,
  }) :  _contentRepository = contentRepository,
        super(ChangesState(date: initialDate))
  {
    _getChangeList();
  }

  final DateTime initialDate;
  final ContentRepository _contentRepository;
  final _Debouncer _debouncer = _Debouncer(milliseconds: 500);

  Future<void> _getChangeList({bool refresh = false}) async {
    final date = state.date;
    emit(state.copyWith(isLoadingList: true));
    try {
      final changeList = await _contentRepository.getChanges(date.toRecentChanges);
      if(state.date!=date) return;
      emit(state.copyWith(changesList: changeList, isLoadingList: false));
    } catch (e) {
      if(state.date!=date) return;
      emit(state.copyWith(
          changesList: [],
          error: Wrapped.value(refresh ? ChangesStateErrors.refresh : ChangesStateErrors.load),
          isLoadingList: false));
      _resetError();
    }
  }

  void _resetError() {
    emit(state.copyWith(error: const Wrapped.value(null)));
  }

  Future<void> refresh() async {
    await _getChangeList(refresh: true);
  }

  Future<void> setDate(DateTime date) async {
    emit(state.copyWith(date: date));
    _debouncer.run(() async {
      await _getChangeList();
    });
  }

}

extension DateTimeToRecentChanges on DateTime {
  String get toRecentChanges => '$year-${month.toString().length>1 ? month : '0$month'}';
}

class _Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  _Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}