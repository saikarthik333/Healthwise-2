import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // IMPORTANT:
  // If Flask runs on same machine:
  // - Chrome: http://127.0.0.1:5000
  // - Android Emulator: http://10.0.2.2:5000
  static const String baseUrl = "http://127.0.0.1:5000";

  static Future<Map<String, dynamic>> predictDisease(
      List<String> symptoms) async {
    final url = Uri.parse("$baseUrl/api/predict");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"symptoms": symptoms}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to get prediction");
    }
  }
}
