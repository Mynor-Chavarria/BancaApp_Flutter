import '../../domain/entities/payment_type_entity.dart';

class PaymentsState {
  const PaymentsState({this.isLoading = false, this.paymentTypes = const []});

  final bool isLoading;
  final List<PaymentTypeEntity> paymentTypes;

  PaymentsState copyWith({
    bool? isLoading,
    List<PaymentTypeEntity>? paymentTypes,
  }) {
    return PaymentsState(
      isLoading: isLoading ?? this.isLoading,
      paymentTypes: paymentTypes ?? this.paymentTypes,
    );
  }
}
