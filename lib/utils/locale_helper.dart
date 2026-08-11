import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Locale resolveInitialLocale(
  SharedPreferences prefs,
  List<Locale> supportedLocales,
) {
  const fallbackLocale = Locale('ru');
  final supportedCodes = supportedLocales
      .map((locale) => locale.languageCode)
      .toSet();

  final savedCode =
      prefs.getString('selected_language_code') ??
      languageCodeFromLabel(prefs.getString('selected_language'));
  if (savedCode != null && supportedCodes.contains(savedCode)) {
    return Locale(savedCode);
  }

  final systemCode =
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  if (supportedCodes.contains(systemCode)) {
    return Locale(systemCode);
  }

  return fallbackLocale;
}

String? languageCodeFromLabel(String? label) {
  if (label == null) return null;
  if (label.contains('English')) return 'en';
  if (label.contains('Кыргызча')) return 'ky';
  if (label.contains('Русский')) return 'ru';
  return null;
}
