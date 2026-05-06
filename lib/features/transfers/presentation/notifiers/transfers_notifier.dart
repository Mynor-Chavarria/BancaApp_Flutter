import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/create_transfer_usecase.dart';
import '../providers/transfers_providers.dart';
import '../state/transfers_state.dart';

class TransfersNotifier extends Notifier<TransfersState> {
  @override
  TransfersState build() => const TransfersState();

  GetTransferTypesUseCase get _getTransferTypesUseCase =>
      ref.read(getTransferTypesUseCaseProvider);

  Future<void> loadTransferTypes() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final types = await _getTransferTypesUseCase();
      state = state.copyWith(isLoading: false, transferTypes: types);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
}
