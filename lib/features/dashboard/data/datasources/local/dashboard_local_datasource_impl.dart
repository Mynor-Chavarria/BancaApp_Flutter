import '../../models/dashboard_account_model.dart';
import 'dashboard_local_datasource.dart';

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  const DashboardLocalDataSourceImpl();

  @override
  Future<List<DashboardAccountModel>> getMyAccounts() async {
    return const [
      DashboardAccountModel(
        id: '0101223344556677',
        productType: 3,
        accountName: 'accountMonetary',
        accountNumber: '0101 2233 4455 6677',
        accountHolderName: '',
        currency: 'GTQ',
        availableBalance: 8425.50,
        currentBalance: 8425.50,
        status: 'active',
      ),
      DashboardAccountModel(
        id: '0101998877665544',
        productType: 4,
        accountName: 'accountSaving',
        accountNumber: '0101 9988 7766 5544',
        accountHolderName: '',
        currency: 'GTQ',
        availableBalance: 15230.00,
        currentBalance: 15230.00,
        status: 'active',
      ),
      DashboardAccountModel(
        id: '4500123456789010',
        productType: 20,
        accountName: 'creditCard',
        accountNumber: '4500 1234 5678 9010',
        accountHolderName: '',
        currency: 'USD',
        availableBalance: 1200.00,
        currentBalance: 300.00,
        creditLimit: 1500.00,
        status: 'active',
      ),
    ];
  }
}
