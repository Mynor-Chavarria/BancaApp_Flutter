import '../../models/dashboard_account_model.dart';

abstract class DashboardFirestoreDataSource {
  Future<List<DashboardAccountModel>> getAccounts({required String uid});

  Future<void> seedAccounts({
    required String uid,
    required List<DashboardAccountModel> accounts,
  });
}
