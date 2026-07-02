import '../../models/dashboard_account_model.dart';
import 'dashboard_local_datasource.dart';

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  const DashboardLocalDataSourceImpl();

  @override
  Future<List<DashboardAccountModel>> getMyAccounts() async {
    return const [
      DashboardAccountModel(
        accountName: 'accountMonetary',
        accountNumber: '0101 2233 4455 6677',
        accountHolderName: '',
        amountInQuetzales: 8425.50,
      ),
      DashboardAccountModel(
        accountName: 'accountSaving',
        accountNumber: '0101 9988 7766 5544',
        accountHolderName: '',
        amountInQuetzales: 15230.00,
      ),
    ];
  }
}
