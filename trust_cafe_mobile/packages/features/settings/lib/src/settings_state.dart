part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.isApiChannelProduction,
    required this.translationTargetCode,
    required this.appThemeMode,
    this.authenticatedUser,
    this.imageSizeThreshold,
  });

  final bool isApiChannelProduction;
  final String translationTargetCode;
  final AppUser? authenticatedUser;
  final String appThemeMode;
  final double? imageSizeThreshold;

  @override
  List<Object?> get props => [
    isApiChannelProduction,
    authenticatedUser,
    translationTargetCode,
    appThemeMode,
    imageSizeThreshold,
  ];

  SettingsState copyWith({
    bool? isApiChannelProduction,
    String? translationTargetCode,
    String? appThemeMode,
    Wrapped<AppUser?>? authenticatedUser,
    Wrapped<double?>? imageSizeThreshold,
  }) {
    return SettingsState(
      isApiChannelProduction:
          isApiChannelProduction ?? this.isApiChannelProduction,
      translationTargetCode:
          translationTargetCode ?? this.translationTargetCode,
      appThemeMode: appThemeMode ?? this.appThemeMode,
      authenticatedUser: authenticatedUser!=null ? authenticatedUser.value : this.authenticatedUser,
      imageSizeThreshold: imageSizeThreshold!=null ? imageSizeThreshold.value : this.imageSizeThreshold,
    );
  }

  @override
  String toString() {
    return 'SettingsState{isApiChannelProduction: $isApiChannelProduction, translationTargetCode: $translationTargetCode, authenticatedUser: $authenticatedUser, appThemeMode: $appThemeMode, imageSizeThreshold: $imageSizeThreshold}';
  }
}