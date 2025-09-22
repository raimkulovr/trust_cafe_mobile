import 'package:equatable/equatable.dart';

class AppUser extends Equatable{
  const AppUser({
    required this.userId,
    required this.slug,
    required this.fname,
    required this.lname,
    required this.userLanguage,
    required this.groups,
    required this.trustLevelInfo,
    required this.voteValue,
    required this.trustLevelInt,
  });

  final String userId;
  final String slug;
  final String fname;
  final String lname;
  final String userLanguage;
  final List<String> groups;
  final String trustLevelInfo;
  final int voteValue;
  final int trustLevelInt;

  const AppUser.guest()
      : userId = 'guest',
        slug = '',
        fname = '',
        lname = '',
        userLanguage = '',
        groups = const [],
        trustLevelInfo = '',
        voteValue = 0,
        trustLevelInt = 0;

  bool get isGuest => this == const AppUser.guest();
  bool get isNotGuest => !isGuest;
  bool get isAdmin => groups.contains('meta-admin');
  bool get canRate => trustLevelInt>=2;

  @override
  List<Object?> get props => [
    userId,
    slug,
    fname,
    lname,
    userLanguage,
    groups,
    trustLevelInfo,
    voteValue,
    trustLevelInt,
  ];

}

class UserVote extends Equatable {
  const UserVote({
    required this.parentSk,
    required this.parentPk,
    required this.isUp,
  });
  final String parentSk;
  final String parentPk;
  final bool isUp;

  @override
  List<Object?> get props => [
    parentSk,
    parentPk,
    isUp,
  ];

}