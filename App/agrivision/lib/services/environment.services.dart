import '../utils/contants.utils.dart';
import '../utils/general.utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class EnvironmentService {
  final String baseUrl = '${AppConstants.baseUrl}/api';

  // ─────────────────────────────────────────
  // WEATHER  →  POST /environment/weather
  // ─────────────────────────────────────────
  Future<Map<String, dynamic>> getWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      final headers = await GeneralUtils.authHeaders();

      final response = await http.post(
        Uri.parse("$baseUrl/environment/weather"),
        headers: headers,
        body: jsonEncode({"lat": lat, "lon": lon}),
      );

      print("WEATHER | ${response.statusCode} | ${response.body}");

      final decoded = jsonDecode(response.body);

      return {
        "success": decoded["success"] ?? false,
        "message": decoded["message"] ?? "Unknown error",
        "statusCode": response.statusCode,
        "details": decoded["details"],         // null if not returned
      };
    } catch (e) {
      print("Get weather error: $e");
      throw Exception("Failed to fetch weather: $e");
    }
  }

  // ─────────────────────────────────────────
  // TODAY WEATHER  →  POST /environment/weather/today
  // ─────────────────────────────────────────
  Future<Map<String, dynamic>> getTodayWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      final headers = await GeneralUtils.authHeaders();

      final response = await http.post(
        Uri.parse("$baseUrl/environment/weather/today"),
        headers: headers,
        body: jsonEncode({"lat": lat, "lon": lon}),
      );

      print("TODAY WEATHER | ${response.statusCode} | ${response.body}");

      final decoded = jsonDecode(response.body);

      return {
        "success": decoded["success"] ?? false,
        "message": decoded["message"] ?? "Unknown error",
        "statusCode": response.statusCode,
        "details": decoded["details"],
      };
    } catch (e) {
      print("Get today weather error: $e");
      throw Exception("Failed to fetch today's weather: $e");
    }
  }

  // ─────────────────────────────────────────
  // LAND DETAILS  →  POST /environment/land-details
  // ─────────────────────────────────────────
  Future<Map<String, dynamic>> getLandDetails({
    required double lat,
    required double lon,
  }) async {
    try {
      final headers = await GeneralUtils.authHeaders();

      final response = await http.post(
        Uri.parse("$baseUrl/environment/land-details"),
        headers: headers,
        body: jsonEncode({"lat": lat, "lon": lon}),
      );

      print("LAND DETAILS | ${response.statusCode} | ${response.body}");

      final decoded = jsonDecode(response.body);

      return {
        "success": decoded["success"] ?? false,
        "message": decoded["message"] ?? "Unknown error",
        "statusCode": response.statusCode,
        "details": decoded["details"],
      };
    } catch (e) {
      print("Get land details error: $e");
      throw Exception("Failed to fetch land details: $e");
    }
  }
}