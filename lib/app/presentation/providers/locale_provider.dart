import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() => null;

  void setLanguageCode(String languageCode) {
    state = Locale(languageCode);
  }
}

final appLocaleProvider =
    NotifierProvider<AppLocaleNotifier, Locale?>(AppLocaleNotifier.new);
