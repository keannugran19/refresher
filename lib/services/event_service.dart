import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:refresher/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventService {
  // fetch all events
  static Future<List<dynamic>> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse("${Config.apiBaseUrl}/events"));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        return decodedData;
      } else {
        throw Exception("Failed to load events: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  // fetch specific event
  static Future<Map<String, dynamic>> fetchEvent(int eventId) async {
    try {
      final response = await http.get(
        Uri.parse("${Config.apiBaseUrl}/events/$eventId"),
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        return decodedData;
      } else {
        throw Exception("Failed to load event: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  // add new event
  static Future<bool> addEvent(Map<String, dynamic> eventData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${Config.apiBaseUrl}/events/store'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(eventData),
    );

    return response.statusCode == 201;
  }
}
