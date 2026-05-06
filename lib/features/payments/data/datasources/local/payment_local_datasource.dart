import '../../models/payment_type_model.dart';

abstract class PaymentLocalDataSource {
  Future<List<PaymentTypeModel>> getPaymentTypes();
}
