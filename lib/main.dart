import 'package:flutter/material.dart';
import 'core/hive/hive_init.dart';
import 'core/router/app_router.dart';
import 'core/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInit.init();

  // Test connexion backend
  final online = await ApiService.isOnline();
  debugPrint('BACKEND STATUS: ${online ? "✅ CONNECTÉ" : "❌ HORS LIGNE"}');

  runApp(const OaraApp());
}

class OaraApp extends StatelessWidget {
  const OaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'OARA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1D9E75),
        ),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
