import '../entities/payment_type_entity.dart';

abstract class PaymentRepository {
  Future<List<PaymentTypeEntity>> getPaymentTypes();
}
