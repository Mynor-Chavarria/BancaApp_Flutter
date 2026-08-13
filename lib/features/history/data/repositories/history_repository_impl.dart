import '../../../auth/domain/entities/auth_session.dart';
import '../../domain/entities/history_entity.dart';
import '../../domain/entities/paginated_transactions_result.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/local/history_local_datasource.dart';
import '../datasources/remote/history_firestore_datasource.dart';
import '../models/account_transaction_model.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  const HistoryRepositoryImpl({
    required HistoryLocalDataSource localDataSource,
    required HistoryFirestoreDataSource firestoreDataSource,
    required AuthSession? Function() sessionProvider,
  }) : _localDataSource = localDataSource,
       _firestoreDataSource = firestoreDataSource,
       _sessionProvider = sessionProvider;

  final HistoryLocalDataSource _localDataSource;
  final HistoryFirestoreDataSource _firestoreDataSource;
  final AuthSession? Function() _sessionProvider;
  static final Map<String, AccountTransactionModel?> _lastTransactionByAccount =
      {};

  @override
  Future<List<AccountTransactionEntity>> getTransactions({
    required String accountId,
    TransactionType? type,
  }) async {
    final session = _sessionProvider();
    if (session == null) {
      return [];
    }

    var models = await _firestoreDataSource.getTransactions(
      uid: session.uid,
      accountId: accountId,
    );
    if (models.isEmpty) {
      final seedTransactions = await _localDataSource.getTransactions(
        accountId,
      );
      await _firestoreDataSource.seedTransactions(
        uid: session.uid,
        accountId: accountId,
        transactions: seedTransactions,
      );
      models = await _firestoreDataSource.getTransactions(
        uid: session.uid,
        accountId: accountId,
      );
    }

    final entities = models.map((m) => m.toEntity()).toList();
    if (type == null) return entities;
    return entities.where((t) => t.type == type).toList();
  }

  @override
  Future<PaginatedTransactionsResult> getTransactionsPage({
    required String accountId,
    int limit = 5,
    bool reset = false,
  }) async {
    final session = _sessionProvider();
    if (session == null) {
      return const PaginatedTransactionsResult(
        transactions: [],
        hasMore: false,
      );
    }

    final cursorKey = '${session.uid}:$accountId';
    if (reset) {
      _lastTransactionByAccount.remove(cursorKey);
    }

    var models = await _firestoreDataSource.getTransactionsPage(
      uid: session.uid,
      accountId: accountId,
      limit: limit,
      startAfter: _lastTransactionByAccount[cursorKey],
    );

    if (models.isEmpty && reset) {
      final seedTransactions = await _localDataSource.getTransactions(
        accountId,
      );
      if (seedTransactions.isNotEmpty) {
        await _firestoreDataSource.seedTransactions(
          uid: session.uid,
          accountId: accountId,
          transactions: seedTransactions,
        );
        models = await _firestoreDataSource.getTransactionsPage(
          uid: session.uid,
          accountId: accountId,
          limit: limit,
        );
      }
    }

    if (models.isNotEmpty) {
      _lastTransactionByAccount[cursorKey] = models.last;
    }

    return PaginatedTransactionsResult(
      transactions: models.map((model) => model.toEntity()).toList(),
      hasMore: models.length == limit,
    );
  }
}
