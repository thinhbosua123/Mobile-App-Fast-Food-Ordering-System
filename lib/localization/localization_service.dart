import 'package:flutter/material.dart';
import 'en.dart' as en;
import 'vi.dart' as vi;

class LocalizationService {
  static Map<String, Map<String, String>> _localizedValues = {
    'en': en.en,
    'vi': vi.vi,
  };

  static Map<String, String> getLocalizedValues(String locale) {
    return _localizedValues[locale] ?? _localizedValues['en']!;
  }
}
