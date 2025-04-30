import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class AuthService {
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("${Config.apiBaseUrl}/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": password,
      }),
    );

    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Failed to register');
    }
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("${Config.apiBaseUrl}/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data.containsKey("access_token")) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", data["access_token"]);
    }
    return data;
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    await http.post(
      Uri.parse("${Config.apiBaseUrl}/logout"),
      headers: {"Authorization": "Bearer $token"},
    );
    prefs.remove("token");
  }

  static Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      return false;
    }

    final response = await http.get(
      Uri.parse(
        "${Config.apiBaseUrl}/user",
      ), // Change to your auth-check endpoint
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
