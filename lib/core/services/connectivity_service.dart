import 'package:http/http.dart' as http;

class ConnectivityService {
  static Future<bool> isOnline() async {
    try {
      final response = await http
          .get(
            Uri.parse('https://api.groq.com'),
          )
          .timeout(const Duration(seconds: 3));
      return response.statusCode < 500;
    } catch (_) {
      return false;
    }
  }
}
