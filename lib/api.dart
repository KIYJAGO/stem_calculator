import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = "http://localhost/stem_calc_api";

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        body: {
          "email": email,
          "password": password,
        },
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      return data["success"] == true;

    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register.php"),
        body: {
          "email": email,
          "password": password,
        },
      ).timeout(const Duration(seconds: 10));

      print("REGISTER STATUS: ${response.statusCode}");
      print("REGISTER BODY: ${response.body}");

      final data = jsonDecode(response.body);
      return data["success"] == true;

    } catch (e) {
      print("Register error: $e");
      return false;
    }
  }
}