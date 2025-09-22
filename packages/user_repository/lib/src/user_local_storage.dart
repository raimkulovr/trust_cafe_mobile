import 'package:key_value_storage/key_value_storage.dart';

typedef IgnoredList = ({Set<String> users, Set<String> branches});

class UserLocalStorage {
  UserLocalStorage(this.noSqlStorage);
  final KeyValueStorage noSqlStorage;

  Future<void> upsertAppUser(AppUserCacheModel user) async {
    final box = await noSqlStorage.appUserBox;
    await box.put(0, user);
  }

  Future<AppUserCacheModel?> getAppUser() async {
    final box = await noSqlStorage.appUserBox;
    return box.get(0);
  }

  Future<void> deleteAppUser() async {
    final box = await noSqlStorage.appUserBox;
    await box.clear();
  }

  Future<void> upsertApiChannel({required bool isProduction}) async {
    final box = await noSqlStorage.apiChannelBox;
    await box.put(0, isProduction);
  }

  Future<bool> isApiChannelProduction() async {
    final box = await noSqlStorage.apiChannelBox;
    return box.get(0) ?? false; //TODO: replace upon publication
  }

  Future<void> upsertTranslationTarget(String newTarget) async {
    final box = await noSqlStorage.translationTargetBox;
    await box.put(0, newTarget);
  }

  Future<String> getTranslationTarget() async {
    final box = await noSqlStorage.translationTargetBox;
    return box.get(0) ?? 'en';
  }

  Future<void> upsertAppThemeMode(String newAppThemeMode) async {
    final box = await noSqlStorage.appThemeModeBox;
    await box.put(0, newAppThemeMode);
  }

  Future<String> getAppThemeMode() async {
    final box = await noSqlStorage.appThemeModeBox;
    return box.get(0) ?? 'system';
  }

  Future<void> upsertIgnoredList(Set<String> ignoredList, {required bool isUsers}) async {
    final box = await noSqlStorage.ignoredListBox;
    await box.put(isUsers ? 'users' : 'branches', ignoredList.toList());
  }

  Future<IgnoredList> getIgnoredList() async {
    final box = await noSqlStorage.ignoredListBox;
    final users = (box.get('users') ?? []).toSet();
    final branches = (box.get('branches') ?? []).toSet();
    final ignoredList = (users: users, branches: branches);
    return ignoredList;
  }

  Future<void> upsertImageSizeThreshold(double? newThreshold) async {
    final box = await noSqlStorage.imageSizeThresholdBox;
    await box.put(0, newThreshold);
  }

  Future<double?> getImageSizeThreshold() async {
    final box = await noSqlStorage.imageSizeThresholdBox;
    return box.get(0);
  }

  Future<void> upsertDraftQuickSave(String encodedDraft) async {
    final box = await noSqlStorage.draftsBox;
    await box.put(0, encodedDraft);
  }

  Future<void> upsertDraft(String id, String encodedDraft) async {
    final box = await noSqlStorage.draftsBox;
    await box.put(id, encodedDraft);
  }

  Future<void> deleteDraft(String id) async {
    final box = await noSqlStorage.draftsBox;
    await box.delete(id);
  }

  Future<String?> getDraftQuickSave() async {
    final box = await noSqlStorage.draftsBox;
    return box.get(0);
  }

  Future<List<String>> getDraftList() async {
    final box = await noSqlStorage.draftsBox;
    final drafts = box.keys
        .where((e) => e!=0,)
        .map((e) => box.get(e),)
        .where((e) => e != null)
        .cast<String>()
        .toList();
    return drafts;
  }

  Future<void> clearStorage({bool deleteAppUser = true}) async {
    await Future.wait([
      if(deleteAppUser) noSqlStorage.appUserBox.then((box) => box.clear()),
      noSqlStorage.clearTemporaryStorage()
    ]);
  }
}
