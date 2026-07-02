import '../../models/dashboard_account_model.dart';

abstract class DashboardLocalDataSource {
  Future<List<DashboardAccountModel>> getMyAccounts();
}
