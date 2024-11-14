import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required UserRepository userRepository,
  }) :  _userRepository = userRepository,
        super(SettingsState(
          isApiChannelProduction: userRepository.isApiChannelProduction(),
          translationTargetCode: userRepository.getTranslationTarget(),
          appThemeMode: userRepository.getAppThemeMode(),
          imageSizeThreshold: userRepository.imageSizeThreshold,
        ))
  {
    _authChangesSubscription = userRepository.getAppUser().listen((user) {
      emit(state.copyWith(authenticatedUser: Wrapped.value(user)));
    });

  }

  late final StreamSubscription _authChangesSubscription;
  final UserRepository _userRepository;

  Future<void> setApiChannel(bool value) async {
    emit(state.copyWith(isApiChannelProduction: value));
    await _userRepository.setApiChannel(value);
  }

  Future<void> setTranslationTarget(String newTarget) async {
    emit(state.copyWith(translationTargetCode: newTarget));
    await _userRepository.setTranslationTarget(newTarget);
  }

  Future<void> setAppThemeMode(String newAppThemeMode) async {
    emit(state.copyWith(appThemeMode: newAppThemeMode));
    await _userRepository.setAppThemeMode(newAppThemeMode);
  }

  Future<void> setImageSizeThreshold(String? newValue) async {
    final value = newValue!=null
        ? double.tryParse(newValue.replaceAll(',', '.').replaceAll('-', '')) ?? 0
        : null;
    emit(state.copyWith(imageSizeThreshold: Wrapped.value(value)));
    await _userRepository.upsertImageSizeThreshold(value);
  }

  Future<void> signOut() async {
    await _userRepository.signOut();
  }

  Future<void> clearNonImageCache() async {
    await _userRepository.clearNonImageCache();
  }

  @override
  Future<void> close() {
    _authChangesSubscription.cancel();
    return super.close();
  }
}
