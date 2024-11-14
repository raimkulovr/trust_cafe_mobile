import 'package:bloc/bloc.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

part 'spider_state.dart';

class SpiderCubit extends Cubit<SpiderState> {
  SpiderCubit({
    required ContentRepository contentRepository,
    required this.url,
  }) :  _contentRepository = contentRepository,
        super(const SpiderState())
  {
    _getSpiderData();
  }

  final ContentRepository _contentRepository;
  final String url;

  Future<void> _getSpiderData() async {
    //TODO: error handling
    emit(const SpiderState(isLoading: true));
    final spiderDataStream = _contentRepository.getSpiderData(url);
    await spiderDataStream.forEach((data) {
      if(!isClosed) emit(state.copyWith(urlData: data));
    });
    if(!isClosed) emit(state.copyWith(isLoading: false));
  }

  Future<void> refreshSpiderData() async {
    //TODO: error handling
    emit(const SpiderState(isLoading: true));
    final spiderDataStream = _contentRepository.getSpiderData(url, refresh: true);
    await spiderDataStream.forEach((data) {
      if(!isClosed) emit(state.copyWith(urlData: data, isLoading: false));
    });
  }

}
