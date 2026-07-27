import 'dart:convert';
import 'package:flutter/services.dart';

class LangService {
  static Map<String, String> _strings = {};
  static String currentLang = 'en';

  static Future<void> load(String langCode) async {
    currentLang = langCode;
    final String jsonStr = await rootBundle.loadString(
      'assets/lang/$langCode.json'
    );
    final Map<String, dynamic> data = jsonDecode(jsonStr);
    _strings = data.map((key, value) => MapEntry(key, value.toString()));
  }

  static String get(String key) {
    return _strings[key] ?? key;
  }
}