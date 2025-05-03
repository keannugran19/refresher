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
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  // fetch searched events
  static Future<List<dynamic>> searchEvents(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.apiBaseUrl}/events?query=$query'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load events');
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
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
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  // add new event
  static Future<bool> addEvent(Map<String, dynamic> eventData) async {
    try {
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
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  // update and event
  static Future<bool> updateEvent(
    Map<String, dynamic> eventData,
    int eventId,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.put(
        Uri.parse('${Config.apiBaseUrl}/events/$eventId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(eventData),
      );

      return response.statusCode == 201;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  // delete an event
  static Future<bool> deleteEvent(int eventId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse('${Config.apiBaseUrl}/events/$eventId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 201;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
