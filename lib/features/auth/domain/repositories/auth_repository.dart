import '../entities/auth_session.dart';

abstract class AuthRepository {
  Future<AuthSession> login({
    required String username,
    required String password,
  });

  Future<AuthSession> register({
    required String fullName,
    required String email,
    required String gender,
    required String password,
  });

  Future<void> logout();

  Future<AuthSession?> getPersistedSession();
}
