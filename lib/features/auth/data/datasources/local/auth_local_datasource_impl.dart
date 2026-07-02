import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/auth_session_model.dart';
import 'auth_local_datasource.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._prefsFactory);

  static const _sessionKey = 'auth_session';

  final Future<SharedPreferences> Function() _prefsFactory;

  @override
  Future<void> saveSession(AuthSessionModel model) async {
    final prefs = await _prefsFactory();
    await prefs.setString(_sessionKey, jsonEncode(model.toJson()));
  }

  @override
  Future<AuthSessionModel?> getSession() async {
    final prefs = await _prefsFactory();
    final raw = prefs.getString(_sessionKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    return AuthSessionModel.fromJson(decoded);
  }

  @override
  Future<void> clearSession() async {
    final prefs = await _prefsFactory();
    await prefs.remove(_sessionKey);
  }
}
