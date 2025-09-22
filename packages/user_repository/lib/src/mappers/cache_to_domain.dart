import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

extension AppUserCacheToDM on AppUserCacheModel {
  AppUser get toDomainModel =>
      AppUser(
        userId: userId,
        slug: slug,
        fname: fname,
        lname: lname,
        userLanguage: userLanguage,
        groups: groups,
        trustLevelInfo: trustLevelInfo,
        voteValue: voteValue,
        trustLevelInt: trustLevelInt,
      );
}
