import 'package:hive/hive.dart';
part 'reactions_cache_model.g.dart';

@HiveType(typeId: 18)
class ReactionsCacheModel {
  ReactionsCacheModel({
    required this.values,
  });

  @HiveField(12)
  final Map<String, int>? values;
}