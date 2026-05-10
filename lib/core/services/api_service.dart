import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl = 'https://oara-backend.onrender.com';

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  ));

  // ── Auth ──────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> register({
    required String nom,
    required String prenom,
    required String profil, // voyant, non_voyant, sourd, muet
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'nom': nom,
        'prenom': prenom,
        'profil': profil,
      });
      return response.data;
    } catch (e) {
      debugPrint('API register error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final response = await _dio.get('/auth/user/$userId');
      return response.data;
    } catch (e) {
      debugPrint('API getUser error: $e');
      return null;
    }
  }

  // ── Sessions ──────────────────────────────────────────────────────────────
  static Future<bool> createSession({
    required String userId,
    required String profil,
    required int dureeSecondes,
    required int messagesCount,
  }) async {
    try {
      await _dio.post('/sessions/', data: {
        'user_id': userId,
        'profil': profil,
        'duree_secondes': dureeSecondes,
        'messages_count': messagesCount,
      });
      return true;
    } catch (e) {
      debugPrint('API createSession error: $e');
      return false;
    }
  }

  static Future<bool> syncBatch(List<Map<String, dynamic>> sessions) async {
    try {
      await _dio.post('/sessions/sync-batch', data: {'sessions': sessions});
      return true;
    } catch (e) {
      debugPrint('API syncBatch error: $e');
      return false;
    }
  }

  // ── OAA ───────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> getOaaScore(String userId) async {
    try {
      final response = await _dio.get('/oaa/score/$userId');
      return response.data;
    } catch (e) {
      debugPrint('API getOaaScore error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getRapportParental(String userId) async {
    try {
      final response = await _dio.get('/oaa/rapport/$userId');
      return response.data;
    } catch (e) {
      debugPrint('API getRapportParental error: $e');
      return null;
    }
  }

  // ── Chat IA ───────────────────────────────────────────────────────────────
  static Future<String?> sendMessage({
    required String message,
    required String profil,
    String? userId,
  }) async {
    try {
      final response = await _dio.post('/chat/', data: {
        'message': message,
        'profil': profil,
        if (userId != null) 'user_id': userId,
      });
      return response.data['response'] as String?;
    } catch (e) {
      debugPrint('API sendMessage error: $e');
      return null;
    }
  }

  // ── Health ────────────────────────────────────────────────────────────────
  static Future<bool> isOnline() async {
    try {
      final response = await _dio.get('/');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
