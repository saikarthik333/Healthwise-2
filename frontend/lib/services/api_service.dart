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

  static Future<List<String>> fetchSymptoms() async {
  final url = Uri.parse("$baseUrl/api/symptoms");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List<String>.from(data["symptoms"]);
  } else {
    throw Exception("Failed to load symptoms");
  }
}

static Future<List<dynamic>> fetchDoctors(String location) async {
  final url = Uri.parse("$baseUrl/api/doctors");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"location": location}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["doctors"];
  } else {
    throw Exception("Failed to fetch doctors");
  }
}


static Future<List<int>> downloadReport({
  required List<String> symptoms,
  required String disease,
  required String specialist,
  required List remedies,
}) async {
  final url = Uri.parse("$baseUrl/api/report");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "symptoms": symptoms,
      "disease": disease,
      "specialist": specialist,
      "remedies": remedies,
    }),
  );

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception("Failed to download report");
  }
}

}
