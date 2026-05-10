import 'package:hive/hive.dart';

part 'session.g.dart';

@HiveType(typeId: 1)
class Session extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String userId;

  @HiveField(2)
  late String subject;

  @HiveField(3)
  late int durationSeconds;

  @HiveField(4)
  late DateTime startedAt;

  @HiveField(5)
  bool isSynced = false;
}