import '../../domain/entities/history_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/local/history_local_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  const HistoryRepositoryImpl({required HistoryLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final HistoryLocalDataSource _localDataSource;

  @override
  Future<List<AccountTransactionEntity>> getTransactions({
    required String accountId,
    TransactionType? type,
  }) async {
    final models = await _localDataSource.getTransactions(accountId);
    final entities = models.map((m) => m.toEntity()).toList();
    if (type == null) return entities;
    return entities.where((t) => t.type == type).toList();
  }
}
