import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _selectedLocale = const Locale('en', 'US');

  Locale get selectedLocale => _selectedLocale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    String? countryCode = prefs.getString('country_code');

    if (languageCode != null && countryCode != null) {
      _selectedLocale = Locale(languageCode, countryCode);
      notifyListeners();
    }
  }

  Future<void> changeLanguage(Locale newLocale) async {
    _selectedLocale = newLocale;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', newLocale.languageCode);
    await prefs.setString('country_code', newLocale.countryCode ?? '');
  }

  static final List<Map<String, dynamic>> supportedLanguages = [
    {'name': 'English', 'locale': const Locale('en', 'US')},
    {'name': 'हिन्दी (Hindi)', 'locale': const Locale('hi', 'IN')},
    {'name': 'తెలుగు (Telugu)', 'locale': const Locale('te', 'IN')},
    {'name': 'தமிழ் (Tamil)', 'locale': const Locale('ta', 'IN')},
    {'name': 'ਪੰਜਾਬੀ (Punjabi)', 'locale': const Locale('pa', 'IN')},
  ];

  static List<Locale> get supportedLocales =>
      supportedLanguages.map((lang) => lang['locale'] as Locale).toList();
}
