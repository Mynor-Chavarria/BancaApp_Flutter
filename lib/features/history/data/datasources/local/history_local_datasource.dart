import '../../models/account_transaction_model.dart';

abstract class HistoryLocalDataSource {
  Future<List<AccountTransactionModel>> getTransactions(String accountId);
}
