import '../../models/auth_session_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> login({
    required String username,
    required String password,
  });

  Future<AuthSessionModel> register({
    required String fullName,
    required String email,
    required String gender,
    required String password,
  });

  Future<void> logout();
}
