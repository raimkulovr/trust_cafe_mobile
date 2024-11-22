import 'dart:async';
import 'dart:developer';

import 'package:domain_models/domain_models.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trust_cafe_api/trust_cafe_api.dart';
import 'package:user_repository/src/mappers/mappers.dart';
import 'package:user_repository/src/user_local_storage.dart';
import 'package:user_repository/src/user_secure_storage.dart';

class UserRepository {
  UserRepository({
    required TrustCafeApi api,
    required UserLocalStorage localStorage,
    required bool isProductionInitial,
    required String targetTranslationInitial,
    required String appThemeModeInitial,
    required IgnoredList ignoredListInitial,
    required double? imageSizeThresholdInitial,
    @visibleForTesting UserSecureStorage? secureStorage,
  })
  :
    _localStorage = localStorage,
    _secureStorage = secureStorage ?? const UserSecureStorage(),
    _api = api,
    imageSizeThreshold = imageSizeThresholdInitial
  {
    _apiChannelSubject.add(isProductionInitial);
    _translationTargetSubject.add(targetTranslationInitial);
    _appThemeModeSubject.add(appThemeModeInitial);
    _ignoredListSubject.add(ignoredListInitial);
    _incomingAuthCredentials = _api.authCredentialsStream().listen(
        (AuthCredentialsResponseModel newCredentials) async {
          log('NEW CREDENTIALS: $newCredentials');
          _apiTokenDataSubject.add(newCredentials.tokenData);
          await upsertTokenData(newCredentials.tokenData.toDomainModel);
          await upsertAppUser(newCredentials.userData.toDomainModel);
        },
        onError: (error, _) async {
          log('CREDENTIALS STREAM ERROR: $error');
          if (error is InvalidRefreshTokenTCApiException) {
            await clearAuthCredentials();
          }
        },
        );
   }

  final TrustCafeApi _api;
  final UserSecureStorage _secureStorage;
  final UserLocalStorage _localStorage;

  late final StreamSubscription<AuthCredentialsResponseModel?>
    _incomingAuthCredentials;

  final BehaviorSubject<AppUser> _userSubject = BehaviorSubject();
  final BehaviorSubject<ApiTokenData?> _apiTokenDataSubject = BehaviorSubject();
  final BehaviorSubject<bool> _apiChannelSubject = BehaviorSubject();
  final BehaviorSubject<String> _translationTargetSubject = BehaviorSubject();
  final BehaviorSubject<String> _appThemeModeSubject = BehaviorSubject();
  final BehaviorSubject<IgnoredList> _ignoredListSubject = BehaviorSubject();
  double? imageSizeThreshold;

  bool isIgnoringAuthor(String slug) => _ignoredListSubject.value.users.contains(slug);
  bool isIgnoringBranch(String slug) => _ignoredListSubject.value.branches.contains(slug);
  Future<void> modifyIgnoreList(String slug, {required bool isUser, required bool add}) async {
    final initialValue = _ignoredListSubject.value;
    late final userList;
    late final branchList;
    if(isUser){
      userList = add ? {slug, ...initialValue.users} : initialValue.users.where((e) => e!=slug,).toSet();
      branchList = initialValue.branches;
    } else {
      userList = initialValue.users;
      branchList = add ? {slug, ...initialValue.branches} : initialValue.branches.where((e) => e!=slug,).toSet();
    }
    final IgnoredList newValue = (users: userList, branches: branchList);
    _ignoredListSubject.add(newValue);
    await _localStorage.upsertIgnoredList(isUser ? newValue.users : newValue.branches, isUsers: isUser);
  }

  Stream<IgnoredList> get ignoredListStream => _ignoredListSubject.stream;

  String getTranslationTarget(){
    return _translationTargetSubject.value;
  }

  Future<void> setTranslationTarget(String newTarget) async {
    if(getTranslationTarget()!=newTarget){
      await _localStorage.upsertTranslationTarget(newTarget);
      _translationTargetSubject.add(newTarget);
    }
  }

  String getAppThemeMode(){
    return _appThemeModeSubject.stream.value;
  }

  Stream<String> getAppThemeModeStream(){
    return _appThemeModeSubject.stream;
  }

  Future<void> setAppThemeMode(String newThemeMode) async {
    if(getTranslationTarget()!=newThemeMode){
      await _localStorage.upsertAppThemeMode(newThemeMode);
      _appThemeModeSubject.add(newThemeMode);
    }
  }

  bool isApiChannelProduction() {
    return _apiChannelSubject.value;
  }

  void authenticateAsGuest() {
    _api.getGuestToken();
  }

  Future<void> setApiChannel(bool isProduction) async {
    if(isApiChannelProduction()!=isProduction){
      await _localStorage.upsertApiChannel(isProduction: isProduction);
      _apiChannelSubject.add(isProduction);
      await _localStorage.clearStorage();
      await clearAuthCredentials();
      Author.clearCache();
    }
  }

  Future<void> clearAuthCredentials() async {
    await _secureStorage.deleteTokenData();
    await _localStorage.deleteAppUser();
    authenticateAsGuest();
  }

  Future<void> upsertTokenData(TokenData tokenData) async {
    await _secureStorage.upsertTokenData(
        accessToken: tokenData.accessToken,
        refreshToken: tokenData.refreshToken,
        accessTimeOut: tokenData.accessTimeOut,
    );
  }

  Future<void> upsertAppUser(AppUser user) async {
    await _localStorage.upsertAppUser(user.toCacheModel);
    if(user!=_userSubject.value) _userSubject.add(user);
  }

  Future<void> upsertImageSizeThreshold(double? newThreshold) async {
    await _localStorage.upsertImageSizeThreshold(newThreshold);
    imageSizeThreshold = newThreshold;
  }

  Future<ApiTokenData?> getTokenData() async {
    if(!_apiTokenDataSubject.hasValue){
      final tokenData = await _secureStorage.getTokenData();
      if (tokenData.contains(null)){
        return null;
      } else {
        final apiTokenData = ApiTokenData(
          accessToken: tokenData[0]!,
          refreshToken: tokenData[1]!,
          accessTimeOut: int.tryParse(tokenData[2]!) ?? 0,);
        _apiTokenDataSubject.add(apiTokenData);
        return apiTokenData;
      }
    } else {
      return _apiTokenDataSubject.value;
    }

  }

  Future<void> authenticateUser({
    required Map<String, dynamic> userData,
    required Map<String, dynamic> tokenData,
  }) async {
    final newCredentials = AuthCredentialsResponseModel(
        userData: AppUserResponseModel.fromJson(userData),
        tokenData: TokenDataResponseModel.fromJson(tokenData));
    _api.authenticateUser(newCredentials: newCredentials);
  }

  Stream<AppUser> getAppUser() async* {
    if (!_userSubject.hasValue) {
      final storedPreference = await _localStorage.getAppUser();
      log('CREDENTIALS getAppUser(): $storedPreference');
      final user = storedPreference?.toDomainModel;
      if(user!=null){
        _api.isGuest = user.isGuest;
        _userSubject.add(user);
      } else {
        authenticateAsGuest();
      }
    }

    yield* _userSubject.stream;
  }

  Future<void> signOut() async {
    final tokenData = await getTokenData();
    await _localStorage.clearStorage();
    await clearAuthCredentials();
    if(tokenData!=null){
      await _api.signOut(tokenData.accessToken);
    }
  }

  Future<void> upsertDraftQuickSave(String encodedDraft) async {
    return await _localStorage.upsertDraftQuickSave(encodedDraft);
  }

  Future<void> upsertDraft(String id, String encodedDraft) async {
    return await _localStorage.upsertDraft(id, encodedDraft);
  }

  Future<void> deleteDraft(String id) async {
    return await _localStorage.deleteDraft(id);
  }

  Future<String?> getDraftQuickSave() async {
    return await _localStorage.getDraftQuickSave();
  }

  Future<List<String>> getDraftList() async {
    return await _localStorage.getDraftList();
  }

  Future<void> clearNonImageCache() async {
    await _localStorage.clearStorage(deleteAppUser: false);
  }

}

