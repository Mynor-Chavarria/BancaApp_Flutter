import '../../domain/entities/history_entity.dart';

class AccountHistoryState {
  const AccountHistoryState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.errorMessage,
    this.allTransactions = const [],
    this.fromDate,
    this.toDate,
    this.selectedType,
  });

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;
  final List<AccountTransactionEntity> allTransactions;
  final DateTime? fromDate;
  final DateTime? toDate;
  final TransactionType? selectedType;

  List<AccountTransactionEntity> get filtered {
    return allTransactions.where((t) {
        if (fromDate != null && t.date.isBefore(fromDate!)) return false;
        final effectiveTo =
            toDate != null
                ? DateTime(toDate!.year, toDate!.month, toDate!.day, 23, 59, 59)
                : null;
        if (effectiveTo != null && t.date.isAfter(effectiveTo)) return false;
        if (selectedType != null && t.type != selectedType) return false;
        return true;
      }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  AccountHistoryState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    Object? errorMessage = _noChange,
    List<AccountTransactionEntity>? allTransactions,
    DateTime? Function()? fromDate,
    DateTime? Function()? toDate,
    TransactionType? Function()? selectedType,
  }) {
    return AccountHistoryState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage:
          identical(errorMessage, _noChange)
              ? this.errorMessage
              : errorMessage as String?,
      allTransactions: allTransactions ?? this.allTransactions,
      fromDate: fromDate != null ? fromDate() : this.fromDate,
      toDate: toDate != null ? toDate() : this.toDate,
      selectedType: selectedType != null ? selectedType() : this.selectedType,
    );
  }
}

const _noChange = Object();
