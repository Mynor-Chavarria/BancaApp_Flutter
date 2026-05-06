import '../../../../../core/network/network.dart';
import '../../models/dashboard_user_model.dart';
import 'dashboard_remote_datasource.dart';

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  const DashboardRemoteDataSourceImpl(this._httpClient);

  final AppHttpClient _httpClient;

  @override
  Future<DashboardUserModel> getCurrentUser() async {
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

    return DashboardUserModel.fromJson(body);
  }
}
