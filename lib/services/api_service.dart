import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000'; // Replace with your base URL

  // Function to register a user
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/signup'); // Append the endpoint to the base URL

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return the response data
      } else {
        // Parse the error response and throw the "detail" field
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['detail'] ?? 'An unknown error occurred');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  // Function to log in a user
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login'); // Append the endpoint to the base URL

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return the response data
      } else {
        // Parse the error response and throw the "detail" field
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['detail'] ?? 'An unknown error occurred');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  // Function to make authenticated API calls
  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$baseUrl/user');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }
}