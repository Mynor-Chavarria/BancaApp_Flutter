import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_payment_types_usecase.dart';
import '../providers/payments_providers.dart';
import '../state/payments_state.dart';

class PaymentsNotifier extends Notifier<PaymentsState> {
  @override
  PaymentsState build() => const PaymentsState();

  GetPaymentTypesUseCase get _useCase =>
      ref.read(getPaymentTypesUseCaseProvider);

  Future<void> loadPaymentTypes() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    final types = await _useCase();
    state = state.copyWith(isLoading: false, paymentTypes: types);
  }
}
