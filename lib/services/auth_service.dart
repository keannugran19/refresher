import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class AuthService {
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
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

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final userId = data['user_id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", data["access_token"]);
        prefs.setInt("user_id", userId);

        return data;
      } else if (response.statusCode == 422) {
        return {'success': false, 'email': data['email']};
      } else {
        return {'success': false, 'message': data['message']};
      }
    } on SocketException {
      return {
        'success': false,
        'message': 'No internet connection. Please try again.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${Config.apiBaseUrl}/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final userId = data['user_id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", data["access_token"]);
        prefs.setInt("user_id", userId);

        return data;
      } else {
        return {'success': false, 'error': data['error']};
      }
    } on SocketException {
      return {
        'success': false,
        'message': 'No internet connection. Please try again.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      final response = await http.post(
        Uri.parse("${Config.apiBaseUrl}/logout"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        prefs.remove("token");
        return {'success': true, 'message': 'Logged out successfully!'};
      } else {
        return {'success': false};
      }
    } on SocketException {
      return {
        'success': false,
        'message': 'No internet connection. Please try again.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      final response = await http.get(
        Uri.parse("${Config.apiBaseUrl}/user"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        return decodedData;
      } else {
        throw Exception("Failed to load event: ${response.statusCode}");
      }
    } on SocketException {
      return {
        'success': false,
        'message': 'No internet connection. Please try again.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  static Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      return false;
    }

    final response = await http.get(
      Uri.parse("${Config.apiBaseUrl}/user"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
