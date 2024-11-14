import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:trust_cafe_api/trust_cafe_api.dart';

extension AppUserResponseToDM on AppUserResponseModel {
  AppUser get toDomainModel =>
      AppUser(
        userId: userId,
        slug: slug,
        fname: fname,
        lname: lname,
        userLanguage: userLanguage,
        groups: groups,
        trustLevelInfo: trustLevelInfo.aka,
        voteValue: voteValue,
        trustLevelInt: trustLevelInfo.trustLevelInt
      );
}

extension TokenDataResponseToDM on TokenDataResponseModel {
  TokenData get toDomainModel =>
      TokenData(
        accessToken: accessToken,
        refreshToken: refreshToken,
        accessTimeOut: accessTimeOut,
        // accessTimeOut: DateTime.now().add(Duration(minutes: 1)).millisecondsSinceEpoch,
      );
}
