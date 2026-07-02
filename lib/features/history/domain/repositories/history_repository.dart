import '../entities/history_entity.dart';

abstract class HistoryRepository {
  Future<List<AccountTransactionEntity>> getTransactions({
    required String accountId,
    TransactionType? type,
  });
}
