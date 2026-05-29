import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GeneralUtils {

  // ─────────────────────────────────────────
  // HELPER  →  builds auth headers with token
  // ─────────────────────────────────────────
  static Future<Map<String, String>> authHeaders() async {
    final _storage = const FlutterSecureStorage();
    final token = await _storage.read(key: "auth_token");
    if (token == null) throw Exception("No auth token found. Please login again.");
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }
}