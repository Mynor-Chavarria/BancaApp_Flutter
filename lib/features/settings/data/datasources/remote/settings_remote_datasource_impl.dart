import '../../../../../core/network/network.dart';
import '../../models/user_profile_model.dart';
import 'settings_remote_datasource.dart';

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  const SettingsRemoteDataSourceImpl(this._httpClient);

  final AppHttpClient _httpClient;

  @override
  Future<UserProfileModel> getCurrentUser() async {
    final response = await _httpClient.get<Map<String, dynamic>>('/auth/me');
    final body = response.data;

    if (body == null) {
      throw const AppException(
        AppError(
          type: AppErrorType.unknown,
          message: 'Respuesta vacia del servidor.',
        ),
      );
    }

    return UserProfileModel.fromJson(body);
  }
}
