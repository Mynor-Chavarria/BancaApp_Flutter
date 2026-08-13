import '../../models/account_transaction_model.dart';

abstract class HistoryFirestoreDataSource {
  Future<List<AccountTransactionModel>> getTransactions({
    required String uid,
    required String accountId,
  });

  Future<List<AccountTransactionModel>> getTransactionsPage({
    required String uid,
    required String accountId,
    required int limit,
    AccountTransactionModel? startAfter,
  });

  Future<void> seedTransactions({
    required String uid,
    required String accountId,
    required List<AccountTransactionModel> transactions,
  });
}
