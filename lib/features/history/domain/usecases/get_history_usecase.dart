import '../entities/history_entity.dart';
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
