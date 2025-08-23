import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

part 'trust_state.dart';

class TrustCubit extends Cubit<TrustState> {
  TrustCubit({
    required ContentRepository contentRepository,
    required this.userSlug,  
  }) : _contentRepository = contentRepository,
        super(const TrustState())
  {
    _getTrustObject();
  }

  final ContentRepository _contentRepository;
  final String userSlug;
  
  void _getTrustObject() async {
    final trustObjectsStream = _contentRepository.getTrustObjectBySlug(userSlug);
    try {
      emit(state.copyWith(isLoading: true));
      await trustObjectsStream.forEach((element) {
        if(isClosed) return;
        emit(state.copyWith(trustObject: element, chosenTrustLevel: element?.trustLevel.toDouble()));
      });
      if(isClosed) return;
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      log('error trying to fetch trust data: $e');
    }
  }

  void saveTrustSetting() async {
    final trustLevel = switch(state.chosenTrustLevel){
      >100 => 100,
      <-20 => -20,
      _ => state.chosenTrustLevel.toInt()
    };

    //TODO: error handling

    _contentRepository.setTrustObject(
        userSlug: userSlug, trustLevel: trustLevel);
  }

  void setChosenTrustLevel(double newValue){
    emit(state.copyWith(chosenTrustLevel: newValue));
  }

}

extension TrustObjectCopy on TrustObject {
  TrustObject copyWith({
    int? trustLevel,
    String? pk,
    String? sk,
    int? updatedAt,
    int? createdAt,
  }) {
    return TrustObject(
      trustLevel: trustLevel ?? this.trustLevel,
      pk: pk ?? this.pk,
      sk: sk ?? this.sk,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
