import 'package:equatable/equatable.dart';

class Author extends Equatable {
  const Author({
    required this.fname,
    required this.userLanguage,
    required this.lname,
    required this.userId,
    required this.slug,
    this.trustLevel = '',
    this.trustName,
    this.membershipType,
  });

  final String fname;
  final String? userLanguage;
  final String lname;
  final String userId;
  final String slug;

  final String? trustLevel;
  final String? trustName;
  final String? membershipType;

  String get fullName => '$fname $lname';

  static const system = Author(
    fname: 'SYSTEM',
    userLanguage: null,
    lname: 'SYSTEM',
    userId: 'SYSTEM',
    slug: 'SYSTEM',
  );

  bool get isSystem => this == system;

  @override
  List<Object?> get props => [
    fname,
    userLanguage,
    lname,
    userId,
    slug,
    trustLevel,
    trustName,
    membershipType,
  ];
}