import '../entities/history_entity.dart';
import '../entities/paginated_transactions_result.dart';

abstract class HistoryRepository {
  Future<List<AccountTransactionEntity>> getTransactions({
    required String accountId,
    TransactionType? type,
  });

  Future<PaginatedTransactionsResult> getTransactionsPage({
    required String accountId,
    int limit = 5,
    bool reset = false,
  });
}
