import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_session.dart';

class ApiService {

  static const String baseUrl = "http://localhost/stem_calc_api";

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        body: {
          "email": email,
          "password": password,
        },
      ).timeout(const Duration(seconds: 10));

      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        UserSession.username = data["username"]?.toString();
        UserSession.userId = data["user_id"]?.toString();
        UserSession.role = data["role"]?.toString();
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

      print("REGISTER STATUS: ${response.statusCode}");
      print("REGISTER BODY: ${response.body}");

      final data = jsonDecode(response.body);
      return data["success"] == true;

    } catch (e) {
      print("Register error: $e");
      return false;
    }
  }

  Future<bool> saveCalculationHistory(String username, String calculation) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/formulas/save_history.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "calculation": calculation,
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["success"] == true;
      }
      return false;
    } catch (e) {
      print("Error saving history: $e");
      return false;
    }
  }

  Future<List<dynamic>> getUserHistory(String username) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/formulas/get_history.php?username=$username"),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print("Error fetching user history: $e");
      return [];
    }
  }

  Future<bool> deleteAccount(String userId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/delete_account.php"),
        body: {"user_id": userId},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["success"] == true;
      }
      return false;
    } catch (e) {
      print("Delete account error: $e");
      return false;
    }
  }

  Future<List<String>> getFavoriteFormulas(String userId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/get_formulas.php"),
        body: {"user_id": userId},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item.toString()).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching formulas: $e");
      return [];
    }
  }

  Future<List<dynamic>> getFormulas() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/formulas/get_formula.php"), 
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      
      if (data is List) {
        return data;
      } else if (data is Map && data["success"] == true) {
        return data["data"] ?? [];
      }
      return [];

    } catch (e) {
      print("NETWORK/CONVERSION CRITICAL ERROR: $e");
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

  Future<bool> addFavoriteFormula(String userId, String name, String formula) async {
    try {
      final response = await http.post(
        // ✅ FIX: Make sure this line does NOT have the word "formulas" in it
        Uri.parse('$baseUrl/add_favorite.php'), 
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "name": name,
          "formula": formula,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print("Error adding favorite: $e");
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

// History
Future<bool> saveHistory(int userId, int formulaId,
    String inputs, String result) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/history/save_history.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "formula_id": formulaId,
        "inputs": inputs,
        "result": result,
      }),
    ).timeout(const Duration(seconds: 10));

    final data = jsonDecode(response.body);
    return data["success"] == true;
  } catch (e) {
    print("Save history error: $e");
    return false;
  }
}

Future<List<dynamic>> getHistory(int userId) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/history/get_history.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    ).timeout(const Duration(seconds: 10));

    final data = jsonDecode(response.body);
    if (data["success"] == true) return data["data"];
    return [];
  } catch (e) {
    print("Get history error: $e");
    return [];
  }
}
}