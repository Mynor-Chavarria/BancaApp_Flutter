import 'package:banca_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../providers/auth_providers.dart';
import '../state/auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  LoginUseCase get _loginUseCase => ref.read(loginUseCaseProvider);
  LogoutUseCase get _logoutUseCase => ref.read(logoutUseCaseProvider);

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<void> login({
    required String username,
    required String password,
    required AppLocalizations l10n,
  }) async {
    final usernameError = _validateUsername(username, l10n);
    if (usernameError != null) {
      state = state.copyWith(errorMessage: usernameError, isSuccess: false);
      return;
    }

    final passwordError = _validatePassword(password, l10n);
    if (passwordError != null) {
      state = state.copyWith(errorMessage: passwordError, isSuccess: false);
      return;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );

    try {
      final session = await _loginUseCase(
        username: username,
        password: password,
      );
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        session: session,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: l10n.loginFailed,
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    await _logoutUseCase();
    state = const AuthState();
  }

  /// Llamado automáticamente cuando el servidor responde 401 (token expirado).
  /// Limpia la sesión local sin mostrar loading y resetea el estado.
  Future<void> forceLogout({AppLocalizations? l10n}) async {
    await _logoutUseCase();
    final message =
        l10n?.sessionExpired ??
        'Tu sesión expiró. Por favor inicia sesión nuevamente.';
    state = const AuthState().copyWith(errorMessage: message);
  }

  String? _validateUsername(String username, AppLocalizations l10n) {
    final value = username.trim();
    if (value.isEmpty) {
      return l10n.usernameRequired;
    }
    return null;
  }

  String? _validatePassword(String password, AppLocalizations l10n) {
    if (password.isEmpty) {
      return l10n.passwordRequired;
    }

    if (password.length < 6) {
      return l10n.passwordMinLength;
    }

    return null;
  }
}
