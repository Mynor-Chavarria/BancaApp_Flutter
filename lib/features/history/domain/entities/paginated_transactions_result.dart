import 'history_entity.dart';

class PaginatedTransactionsResult {
  const PaginatedTransactionsResult({
    required this.transactions,
    required this.hasMore,
  });

  final List<AccountTransactionEntity> transactions;
  final bool hasMore;
}
