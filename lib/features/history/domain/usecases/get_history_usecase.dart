import '../entities/history_entity.dart';
import '../entities/paginated_transactions_result.dart';
import '../repositories/history_repository.dart';

class GetAccountTransactionsUseCase {
  const GetAccountTransactionsUseCase(this._repository);

  final HistoryRepository _repository;

  Future<List<AccountTransactionEntity>> call({
    required String accountId,
    TransactionType? type,
  }) {
    return _repository.getTransactions(accountId: accountId, type: type);
  }
}

class GetAccountTransactionsPageUseCase {
  const GetAccountTransactionsPageUseCase(this._repository);

  final HistoryRepository _repository;

  Future<PaginatedTransactionsResult> call({
    required String accountId,
    int limit = 5,
    bool reset = false,
  }) {
    return _repository.getTransactionsPage(
      accountId: accountId,
      limit: limit,
      reset: reset,
    );
  }
}
