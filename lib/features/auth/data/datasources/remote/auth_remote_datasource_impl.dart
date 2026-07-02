import '../../../../../core/network/network.dart';
import '../../models/auth_session_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._httpClient);

  final AppHttpClient _httpClient;

  @override
  Future<AuthSessionModel> login({
    required String username,
    required String password,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'username': username.trim(),
        'password': password,
        'expiresInMins': 5,
      },
    );

    final body = response.data;
    if (body == null) {
      throw const AppException(
        AppError(
          type: AppErrorType.unknown,
          message: 'Respuesta vacia del servidor.',
        ),
      );
    }

    return AuthSessionModel.fromJson(body);
  }
}
