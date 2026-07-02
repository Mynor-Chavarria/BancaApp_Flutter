import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_session.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default(true) bool obscurePassword,
    String? errorMessage,
    AuthSession? session,
  }) = _AuthState;
}
