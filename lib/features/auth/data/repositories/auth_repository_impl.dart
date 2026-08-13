import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/auth_session_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    final sessionModel = await _remoteDataSource.login(
      username: username,
      password: password,
    );

    await _localDataSource.saveSession(sessionModel);
    return sessionModel.toEntity();
  }

  @override
  Future<AuthSession> register({
    required String fullName,
    required String email,
    required String gender,
    required String password,
  }) async {
    final sessionModel = await _remoteDataSource.register(
      fullName: fullName,
      email: email,
      gender: gender,
      password: password,
    );

    await _localDataSource.saveSession(sessionModel);
    return sessionModel.toEntity();
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
    await _localDataSource.clearSession();
  }

  @override
  Future<AuthSession?> getPersistedSession() async {
    final session = await _localDataSource.getSession();
    return session?.toEntity();
  }
}
