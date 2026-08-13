import 'package:banca_app/core/errors/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_dashboard_usecase.dart';
import '../providers/dashboard_providers.dart';
import '../state/dashboard_state.dart';

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() => const DashboardState();

  GetDashboardUseCase get _getDashboardUseCase =>
      ref.read(getDashboardUseCaseProvider);

  Future<void> loadAccounts() async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final accounts = await _getDashboardUseCase();
      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
        accounts: accounts,
      );
    } on AppException catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.error.message,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No fue posible cargar las cuentas: $error',
      );
    }
  }
}
