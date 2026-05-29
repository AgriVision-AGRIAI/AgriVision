import '../utils/contants.utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl = AppConstants.baseUrl;

  final _storage = const FlutterSecureStorage();

  // ─────────────────────────────────────────
  // LOGIN  →  POST /auth/login
  // ─────────────────────────────────────────
  Future<Map<String, dynamic>> login(String phonenumber) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phonenumber": phonenumber}),
      );

      print("LOGIN | ${response.statusCode} | ${response.body}");

      final decoded = jsonDecode(response.body);

      return {
        "success": decoded["success"] ?? false,
        "message": decoded["message"] ?? "Unknown error",
        "statusCode": response.statusCode,
      };
    } catch (e) {
      print("Login error: $e");
      throw Exception("Login failed: $e");
    }
  }

  // ─────────────────────────────────────────
  // VERIFY OTP  →  POST /auth/verify
  // saves token to secure storage on success
  // ─────────────────────────────────────────
  Future<Map<String, dynamic>> verify(String phonenumber, String otp) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/verify"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phonenumber": phonenumber, "otp": otp}),
      );

      print("VERIFY | ${response.statusCode} | ${response.body}");

      final decoded = jsonDecode(response.body);

      // ── persist token if returned ──────────
      if (decoded["token"] != null) {
        await _storage.write(key: "auth_token", value: decoded["token"]);
        print("Token saved to secure storage.");
      }

      return {
        "success": decoded["success"] ?? false,
        "message": decoded["message"] ?? "Unknown error",
        "statusCode": response.statusCode,
        "token": decoded["token"],         // may be null if OTP failed
      };
    } catch (e) {
      print("Verify error: $e");
      throw Exception("OTP verification failed: $e");
    }
  }

  // ─────────────────────────────────────────
  // RESEND OTP  →  POST /auth/resend-otp
  // ─────────────────────────────────────────
  Future<Map<String, dynamic>> resendOtp(String phonenumber) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/resend-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phonenumber": phonenumber}),
      );

      print("RESEND OTP | ${response.statusCode} | ${response.body}");

      final decoded = jsonDecode(response.body);

      return {
        "success": decoded["success"] ?? false,
        "message": decoded["message"] ?? "Unknown error",
        "statusCode": response.statusCode,
      };
    } catch (e) {
      print("Resend OTP error: $e");
      throw Exception("Resend OTP failed: $e");
    }
  }

  // ─────────────────────────────────────────
  // LOGOUT  →  clears token from storage
  // ─────────────────────────────────────────
  Future<void> logout() async {
    await _storage.delete(key: "auth_token");
    print("Token cleared.");
  }

  // ─────────────────────────────────────────
  // GET TOKEN  →  used by other services
  // ─────────────────────────────────────────
  Future<String?> getToken() async {
    return await _storage.read(key: "auth_token");
  }
}