import '../../models/dashboard_user_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardUserModel> getCurrentUser();
}
