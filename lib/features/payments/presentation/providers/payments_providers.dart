import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/payment_local_datasource.dart';
import '../../data/datasources/local/payment_local_datasource_impl.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/usecases/get_payment_types_usecase.dart';

final paymentLocalDataSourceProvider = Provider<PaymentLocalDataSource>((ref) {
  return const PaymentLocalDataSourceImpl();
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(
    localDataSource: ref.watch(paymentLocalDataSourceProvider),
  );
});

final getPaymentTypesUseCaseProvider = Provider<GetPaymentTypesUseCase>((ref) {
  return GetPaymentTypesUseCase(ref.watch(paymentRepositoryProvider));
});
