import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session.freezed.dart';

@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String uid,
    required int userId,
    required String username,
    required String email,
    required String accessToken,
    required String refreshToken,
    String? firstName,
    String? lastName,
    String? image,
    String? gender,
  }) = _AuthSession;
}
