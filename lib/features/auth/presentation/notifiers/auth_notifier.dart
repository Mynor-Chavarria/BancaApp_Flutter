import 'package:banca_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/presentation/controllers/global_loader_controller.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/restore_session_usecase.dart';
import '../providers/auth_providers.dart';
import '../state/auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future.microtask(_restoreSession);
    return const AuthState(isLoading: true);
  }

  LoginUseCase get _loginUseCase => ref.read(loginUseCaseProvider);
  RegisterUseCase get _registerUseCase => ref.read(registerUseCaseProvider);
  LogoutUseCase get _logoutUseCase => ref.read(logoutUseCaseProvider);
  RestoreSessionUseCase get _restoreSessionUseCase =>
      ref.read(restoreSessionUseCaseProvider);

  Future<void> _restoreSession() async {
    try {
      final session = await _restoreSessionUseCase();
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        session: session,
      );
      if (session != null) {
        _registerPushNotifications(session.uid);
      }
    } catch (_) {
      state = const AuthState();
    }
  }

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
    final usernameError = _validateEmail(username, l10n);
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
      _registerPushNotifications(session.uid);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: l10n.loginFailed,
      );
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String gender,
    required String password,
    required AppLocalizations l10n,
  }) async {
    final fullNameError = _validateFullName(fullName, l10n);
    if (fullNameError != null) {
      state = state.copyWith(errorMessage: fullNameError, isSuccess: false);
      return;
    }

    final emailError = _validateEmail(email, l10n);
    if (emailError != null) {
      state = state.copyWith(errorMessage: emailError, isSuccess: false);
      return;
    }

    final genderError = _validateGender(gender, l10n);
    if (genderError != null) {
      state = state.copyWith(errorMessage: genderError, isSuccess: false);
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
      final session = await _registerUseCase(
        fullName: fullName,
        email: email,
        gender: gender,
        password: password,
      );
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        session: session,
      );
      _registerPushNotifications(session.uid);
    } on AppException catch (error) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: error.error.message,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: l10n.registrationFailed,
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
  /// Muestra el loader con un mensaje, limpia la sesión y lo oculta.
  Future<void> forceLogout({AppLocalizations? l10n}) async {
    final loaderMessage = l10n?.sessionEnded ?? 'Sesión finalizada';
    GlobalLoaderController.instance.show(message: loaderMessage);
    await Future.wait([
      _logoutUseCase(),
      Future.delayed(const Duration(seconds: 2)),
    ]);
    GlobalLoaderController.instance.hide();
    state = const AuthState();
  }

  Future<void> _registerPushNotifications(String uid) async {
    try {
      await ref
          .read(pushNotificationsServiceProvider)
          .registerDeviceForUser(uid);
    } catch (_) {
      // Push notifications should not block authentication.
    }
  }

  String? _validateFullName(String fullName, AppLocalizations l10n) {
    if (fullName.trim().isEmpty) {
      return l10n.fullNameRequired;
    }

    return null;
  }

  String? _validateEmail(String username, AppLocalizations l10n) {
    final value = username.trim();
    if (value.isEmpty) {
      return l10n.emailRequired;
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) {
      return l10n.emailInvalid;
    }

    return null;
  }

  String? _validateGender(String gender, AppLocalizations l10n) {
    if (gender.trim().isEmpty) {
      return l10n.genderRequired;
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
