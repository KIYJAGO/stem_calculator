import 'package:flutter/material.dart';
import 'lang_service.dart';

class LangNotifier extends ChangeNotifier {
  static final LangNotifier instance = LangNotifier._();
  LangNotifier._();

  String _currentLang = 'en';
  String get currentLang => _currentLang;

  Future<void> setLanguage(String langCode) async {
    await LangService.load(langCode);
    _currentLang = langCode;
    notifyListeners();
  }
}