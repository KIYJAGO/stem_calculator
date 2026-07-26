import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_session.dart';

class ApiService {
  static const String baseUrl = "http://localhost/stem_calc_api";

  // Authentication
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        body: {"email": email, "password": password},
      ).timeout(const Duration(seconds: 10));

      // print("LOGIN STATUS: ${response.statusCode}");
      // print("LOGIN BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        UserSession.username = data["username"]?.toString();
        UserSession.userId   = data["user_id"]?.toString();
        UserSession.role     = data["role"]?.toString();
      }

      return data;
    } catch (e) {
      print("Login error: $e");
      return {"success": false};
    }
  }

  Future<bool> register(String email, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register.php"),
        body: {
          "email": email,
          "username": username,
          "password": password,
        },
      ).timeout(const Duration(seconds: 10));

      // print("REGISTER STATUS: ${response.statusCode}");
      // print("REGISTER BODY: ${response.body}");

      final data = jsonDecode(response.body);
      return data["success"] == true;
    } catch (e) {
      print("Register error: $e");
      return false;
    }
  }

  Future<bool> deleteAccount(String userId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/delete_account.php"),
        body: {"user_id": userId},
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      return data["success"] == true;
    } catch (e) {
      print("Delete account error: $e");
      return false;
    }
  }

  // Formula
  Future<List<dynamic>> getFormulas() async {
    try {
      final response = await http.get(
        Uri.parse(
          "$baseUrl/formulas/get_formula.php?t=${DateTime.now().millisecondsSinceEpoch}"
        ),
      ).timeout(const Duration(seconds: 10));


      final data = jsonDecode(response.body);
      if (data is List) return data;
      if (data is Map && data["success"] == true) return data["data"] ?? [];
      return [];
    } catch (e) {
      print("Get formulas error: $e");
      return [];
    }
  }

  Future<bool> addFormula(String subject, String name, String formula,
      String variables, String description) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/formulas/add_formula.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "subject": subject,
          "name": name,
          "formula": formula,
          "variables": variables,
          "description": description,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      return data["success"] == true;
    } catch (e) {
      print("Add formula error: $e");
      return false;
    }
  }

  Future<bool> editFormula(int id, String subject, String name,
      String formula, String variables, String description) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/formulas/edit_formula.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
          "subject": subject,
          "name": name,
          "formula": formula,
          "variables": variables,
          "description": description,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      return data["success"] == true;
    } catch (e) {
      print("Edit formula error: $e");
      return false;
    }
  }

  Future<bool> deleteFormula(int id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/formulas/delete_formula.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id}),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      return data["success"] == true;
    } catch (e) {
      print("Delete formula error: $e");
      return false;
    }
  }

  // Save history
  Future<bool> saveHistory(String username, String calculation) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/history/save_history.php"),
        body: {
          "username": username,
          "calculation": calculation,
        },
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      return data["success"] == true;
    } catch (e) {
      print("Save history error: $e");
      return false;
    }
  }

  // Get history
  Future<List<dynamic>> getHistory(String username) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/history/get_history.php?username=$username"),
      ).timeout(const Duration(seconds: 10));

      print("GET HISTORY STATUS: ${response.statusCode}");
      print("GET HISTORY BODY: ${response.body}");

      final data = jsonDecode(response.body);
      if (data is List) return data;
      return [];

    } catch (e) {
      print("Get history error: $e");
      return [];
    }
  }

  Future<bool> deleteHistory(int id) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/history/delete_history.php"),
      body: {"id": id.toString()},
    ).timeout(const Duration(seconds: 10));

    final data = jsonDecode(response.body);
    return data["success"] == true;
  } catch (e) {
    print("Delete history error: $e");
    return false;
  }
  }
}