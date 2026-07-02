import '../../domain/entities/dashboard_entity.dart';

class DashboardState {
  const DashboardState({
    this.isLoading = false,
    this.errorMessage,
    this.accounts = const [],
  });

  final bool isLoading;
  final String? errorMessage;
  final List<DashboardEntity> accounts;

  DashboardState copyWith({
    bool? isLoading,
    Object? errorMessage = _noChange,
    List<DashboardEntity>? accounts,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          identical(errorMessage, _noChange)
              ? this.errorMessage
              : errorMessage as String?,
      accounts: accounts ?? this.accounts,
    );
  }
}

const _noChange = Object();
