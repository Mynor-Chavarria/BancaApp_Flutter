import 'package:banca_app/features/login/domain/usecases/get_login_usecase.dart';
import 'package:banca_app/features/login/presentation/state/login_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._getLoginUseCase)
    : super(
        LoginState(
          title: 'Login',
          logged: false,
          obscurePassword: true,
          isLoading: false,
        ),
      );

  final GetLoginUseCase _getLoginUseCase;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Completa correo y contraseña.',
          clearErrorMessage: false,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    await _getLoginUseCase();
    emit(state.copyWith(isLoading: false, logged: true));
  }

  void clearError() {
    emit(state.copyWith(clearErrorMessage: true));
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
