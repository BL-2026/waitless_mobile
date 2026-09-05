import 'package:flutter/material.dart';

enum AppLanguage {
  en,
  fr,
  ar,
  es;

  String get code => name;

  Locale get locale => Locale(code);

  String get nativeName => switch (this) {
        AppLanguage.en => 'English',
        AppLanguage.fr => 'Français',
        AppLanguage.ar => 'العربية',
        AppLanguage.es => 'Español',
      };

  String get flag => switch (this) {
        AppLanguage.en => '🇬🇧',
        AppLanguage.fr => '🇫🇷',
        AppLanguage.ar => '🇲🇦',
        AppLanguage.es => '🇪🇸',
      };

  static const supportedLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
    Locale('es'),
  ];

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (language) => language.code == code,
      orElse: () => AppLanguage.fr,
    );
  }
}
