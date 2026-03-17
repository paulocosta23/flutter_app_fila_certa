import 'package:flutter/foundation.dart';

class SettingsController extends ChangeNotifier {
  String _language = 'pt_BR';
  double _textScale = 1.0; // 0.9 ~ 1.4
  bool _darkMode = false;
  bool _highContrast = false;

  String get language => _language;
  double get textScale => _textScale;
  bool get darkMode => _darkMode;
  bool get highContrast => _highContrast;

  void setLanguage(String lang) {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
  }

  void setTextScale(double scale) {
    final clamped = scale.clamp(0.9, 1.4);
    if (_textScale == clamped) return;
    _textScale = clamped;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    if (_darkMode == value) return;
    _darkMode = value;
    notifyListeners();
  }

  void setHighContrast(bool value) {
    if (_highContrast == value) return;
    _highContrast = value;
    notifyListeners();
  }

  void updateAll({
    String? language,
    double? textScale,
    bool? darkMode,
    bool? highContrast,
  }) {
    var changed = false;
    if (language != null && _language != language) {
      _language = language;
      changed = true;
    }
    if (textScale != null && _textScale != textScale) {
      _textScale = textScale.clamp(0.9, 1.4);
      changed = true;
    }
    if (darkMode != null && _darkMode != darkMode) {
      _darkMode = darkMode;
      changed = true;
    }
    if (highContrast != null && _highContrast != highContrast) {
      _highContrast = highContrast;
      changed = true;
    }
    if (changed) notifyListeners();
  }
}