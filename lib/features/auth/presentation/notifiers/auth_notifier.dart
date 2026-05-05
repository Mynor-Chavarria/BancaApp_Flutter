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
  }) async {
    final usernameError = _validateUsername(username);
    if (usernameError != null) {
      state = state.copyWith(errorMessage: usernameError, isSuccess: false);
      return;
    }

    final passwordError = _validatePassword(password);
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
        errorMessage: 'No fue posible iniciar sesion. Verifica tus credenciales.',
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    await _logoutUseCase();
    state = const AuthState();
  }

  String? _validateUsername(String username) {
    final value = username.trim();
    if (value.isEmpty) {
      return 'El usuario es obligatorio.';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'La contrasena es obligatoria.';
    }

    if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }

    return null;
  }
}
