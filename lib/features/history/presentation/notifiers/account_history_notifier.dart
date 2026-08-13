import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/history_entity.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../providers/history_providers.dart';
import '../state/account_history_state.dart';

class AccountHistoryNotifier extends Notifier<AccountHistoryState> {
  @override
  AccountHistoryState build() {
    final now = DateTime.now();
    _pageUseCase = ref.watch(getAccountTransactionsPageUseCaseProvider);
    return AccountHistoryState(
      fromDate: now.subtract(const Duration(days: 30)),
      toDate: now,
    );
  }

  late final GetAccountTransactionsPageUseCase _pageUseCase;

  Future<void> loadTransactions(String accountId) async {
    await loadFirstPage(accountId);
  }

  Future<void> loadFirstPage(String accountId) async {
    state = state.copyWith(
      isLoading: true,
      isLoadingMore: false,
      hasMore: true,
      errorMessage: null,
      allTransactions: [],
    );

    try {
      final page = await _pageUseCase(
        accountId: accountId,
        limit: 5,
        reset: true,
      );
      state = state.copyWith(
        isLoading: false,
        allTransactions: page.transactions,
        hasMore: page.hasMore,
      );
    } on AppException catch (error) {
      state = state.copyWith(
        isLoading: false,
        hasMore: false,
        errorMessage: error.error.message,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        hasMore: false,
        errorMessage: 'No fue posible cargar movimientos: $error',
      );
    }
  }

  Future<void> loadNextPage(String accountId) async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, errorMessage: null);

    try {
      final page = await _pageUseCase(accountId: accountId, limit: 5);
      state = state.copyWith(
        isLoadingMore: false,
        allTransactions: [...state.allTransactions, ...page.transactions],
        hasMore: page.hasMore,
      );
    } on AppException catch (error) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: error.error.message,
      );
    } catch (error) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: 'No fue posible cargar mas movimientos: $error',
      );
    }
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
