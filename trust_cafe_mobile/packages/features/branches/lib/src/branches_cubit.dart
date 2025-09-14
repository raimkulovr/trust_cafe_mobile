import 'package:bloc/bloc.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

part 'branches_state.dart';

class BranchesCubit extends Cubit<BranchesState> {
  BranchesCubit({
    required ContentRepository contentRepository,
    Subwiki? selectedSubwiki,
  }) : _contentRepository = contentRepository,
        super(BranchesState(isLoading: true, subwikiList: [], selectedItem: selectedSubwiki))
  {
    getSubwikis();
  }

  final ContentRepository _contentRepository;

  void getSubwikis({String? selectedSubwiki, bool refresh = false}){
    _contentRepository.getSubwikis(refresh: refresh).then((value) {
      emit(BranchesState(
          isLoading: false,
          subwikiList: value.$1,
          lastUpdated: value.$2,
          selectedItem: state.selectedItem,
      ));
    }, onError: (error){
      emit(state.copyWith(error: Wrapped.value(error), isLoading: false));
      throw error;
    });
  }

  void setSelectedItem(Subwiki? selectedSubwiki) {
    emit(state.copyWith(selectedItem: Wrapped.value(selectedSubwiki)));
  }

  Future<void> refreshSubwikis() async {
    emit(state.copyWith(isLoading: true));
    getSubwikis(refresh: true);
  }

}
