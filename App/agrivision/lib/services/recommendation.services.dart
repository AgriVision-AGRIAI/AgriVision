import '../utils/contants.utils.dart';
import '../utils/general.utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendationService {
  final String baseUrl = '${AppConstants.baseUrl}/api';

  // ─────────────────────────────────────────
  // CROP RECOMMENDATION  →  POST /recommend/crop
  // ─────────────────────────────────────────
  Future<Map<String, dynamic>> getCropRecommendation({
    required double lat,
    required double lon,
  }) async {
    try {
      final headers = await GeneralUtils.authHeaders();

      final response = await http.post(
        Uri.parse("$baseUrl/recommend/crop"),
        headers: headers,
        body: jsonEncode({
          "details": {
            "latitude": lat,
            "longitude": lon,
          },
        }),
      );

      print("CROP RECOMMEND | ${response.statusCode} | ${response.body}");

      final decoded = jsonDecode(response.body);

      return {
        "success": decoded["success"] ?? false,
        "message": decoded["message"] ?? "Unknown error",
        "statusCode": response.statusCode,
        "details": decoded["details"], // null if not returned
      };
    } catch (e) {
      print("Crop recommendation error: $e");
      throw Exception("Failed to fetch crop recommendation: $e");
    }
  }

  // ─────────────────────────────────────────
  // FERTILIZER RECOMMENDATION  →  POST /recommend/fertilizer
  // ─────────────────────────────────────────
  Future<Map<String, dynamic>> getFertilizerRecommendation({
    required double lat,
    required double lon,
    required String crop,
  }) async {
    try {
      final headers = await GeneralUtils.authHeaders();

      final response = await http.post(
        Uri.parse("$baseUrl/recommend/fertilizer"),
        headers: headers,
        body: jsonEncode({"lat": lat, "lon": lon, "crop": crop}),
      );

      print("FERTILIZER RECOMMEND | ${response.statusCode} | ${response.body}");

      final decoded = jsonDecode(response.body);

      return {
        "success": decoded["success"] ?? false,
        "message": decoded["message"] ?? "Unknown error",
        "statusCode": response.statusCode,
        "details": decoded["details"],
      };
    } catch (e) {
      print("Fertilizer recommendation error: $e");
      throw Exception("Failed to fetch fertilizer recommendation: $e");
    }
  }
}
