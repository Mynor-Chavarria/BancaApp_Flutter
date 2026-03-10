import 'package:flutter/material.dart';

import '../../../../../app/presentation/controllers/locale_controller.dart';

class SettingsProvider extends ChangeNotifier {
  String? get currentLanguageCode => appLocaleController.value?.languageCode;

  void setLanguageCode(String languageCode) {
    if (currentLanguageCode == languageCode) {
      return;
    }
    appLocaleController.setLanguageCode(languageCode);
    notifyListeners();
  }
}
