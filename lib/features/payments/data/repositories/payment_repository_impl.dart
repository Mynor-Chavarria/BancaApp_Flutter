import '../../domain/entities/payment_type_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/local/payment_local_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  const PaymentRepositoryImpl({required PaymentLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final PaymentLocalDataSource _localDataSource;

  @override
  Future<List<PaymentTypeEntity>> getPaymentTypes() async {
    final models = await _localDataSource.getPaymentTypes();
    return models.map((m) => m.toEntity()).toList(growable: false);
  }
}
