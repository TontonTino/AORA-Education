import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late int profileIndex;

  @HiveField(3)
  late DateTime createdAt;

  @HiveField(4)
  bool isSynced = false;
}