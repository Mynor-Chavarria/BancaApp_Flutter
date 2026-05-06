import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/history_entity.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../providers/history_providers.dart';
import '../state/account_history_state.dart';

class AccountHistoryNotifier extends Notifier<AccountHistoryState> {
  @override
  AccountHistoryState build() {
    final now = DateTime.now();
    _useCase = ref.watch(getAccountTransactionsUseCaseProvider);
    return AccountHistoryState(
      fromDate: now.subtract(const Duration(days: 30)),
      toDate: now,
    );
  }

  late final GetAccountTransactionsUseCase _useCase;
  Future<void> loadTransactions(String accountId) async {
    state = state.copyWith(isLoading: true);
    final transactions = await _useCase(accountId: accountId);
    state = state.copyWith(isLoading: false, allTransactions: transactions);
  }

  void setFromDate(DateTime? date) {
    if (date == null) {
      state = state.copyWith(fromDate: () => null);
      return;
    }
    // Ensure range does not exceed 1 month
    final maxTo = DateTime(date.year, date.month + 1, date.day);
    final currentTo = state.toDate;
    final newTo =
        (currentTo == null || currentTo.isAfter(maxTo)) ? maxTo : currentTo;
    state = state.copyWith(fromDate: () => date, toDate: () => newTo);
  }

  void setToDate(DateTime? date) {
    if (date == null) {
      state = state.copyWith(toDate: () => null);
      return;
    }
    // Ensure range does not exceed 1 month
    final minFrom = DateTime(date.year, date.month - 1, date.day);
    final currentFrom = state.fromDate;
    final newFrom =
        (currentFrom == null || currentFrom.isBefore(minFrom))
            ? minFrom
            : currentFrom;
    state = state.copyWith(toDate: () => date, fromDate: () => newFrom);
  }

  void setTransactionType(TransactionType? type) {
    state = state.copyWith(selectedType: () => type);
  }

  void clearFilters() {
    final now = DateTime.now();
    state = state.copyWith(
      fromDate: () => now.subtract(const Duration(days: 30)),
      toDate: () => now,
      selectedType: () => null,
    );
  }
}
