import '../entities/payment_type_entity.dart';
import '../repositories/payment_repository.dart';

class GetPaymentTypesUseCase {
  const GetPaymentTypesUseCase(this._repository);

  final PaymentRepository _repository;

  Future<List<PaymentTypeEntity>> call() => _repository.getPaymentTypes();
}
