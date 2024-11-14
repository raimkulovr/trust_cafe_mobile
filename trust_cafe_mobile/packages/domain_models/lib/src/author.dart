import 'package:equatable/equatable.dart';

class Author extends Equatable {
  const Author.internal({
    required this.fname,
    required this.userLanguage,
    required this.lname,
    required this.userId,
    required this.slug,
    this.trustLevel,
    this.trustName,
    this.membershipType,
  });

  static final Map<String, Author> _cache = {'SYSTEM': Author.system};
  // static List<Author> get authors => _cache.values.toList(growable: false);

  factory Author({
    required String fname,
    required String? userLanguage,
    required String lname,
    required String userId,
    required String slug,
    double? trustLevel,
    String? trustName,
    String? membershipType,
  }){
    if (_cache.containsKey(userId)) {
      final cachedAuthor = _cache[userId]!;
      if(trustName==null && cachedAuthor.trustName!=null){
        return cachedAuthor;
      }
    }
    final author = Author.internal(
      fname: fname,
      userLanguage: userLanguage,
      lname: lname,
      userId: userId,
      slug: slug,
      trustLevel: trustLevel,
      trustName: trustName,
      membershipType: membershipType,
    );
    _cache[userId] = author;
    return author;
  }

  static void clearCache() {
    _cache.clear();
  }

  final String fname;
  final String? userLanguage;
  final String lname;
  final String userId;
  final String slug;

  final double? trustLevel;
  final String? trustName;
  final String? membershipType;

  String get fullName => '$fname $lname';

  static const system = Author.internal(fname: 'SYSTEM', userLanguage: null, lname: 'SYSTEM', userId: 'SYSTEM', slug: 'SYSTEM');
  bool get isSystem => this==system;

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