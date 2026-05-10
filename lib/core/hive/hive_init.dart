import 'package:hive_flutter/hive_flutter.dart';
import 'models/user_profile.dart';
import 'models/session.dart';

class HiveInit {
  static const String boxProfiles = 'profiles';
  static const String boxSessions = 'sessions';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(SessionAdapter());
    await Hive.openBox<UserProfile>(boxProfiles);
    await Hive.openBox<Session>(boxSessions);
  }
}