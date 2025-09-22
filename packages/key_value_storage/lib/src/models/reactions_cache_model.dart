import 'package:hive_ce/hive.dart';

class ReactionsCacheModel extends HiveObject {
  ReactionsCacheModel({
    required this.values,
  });

  final Map<String, int>? values;
}