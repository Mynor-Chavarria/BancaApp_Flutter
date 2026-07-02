import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/transfer_local_datasource.dart';
import '../../data/datasources/local/transfer_local_datasource_impl.dart';
import '../../data/repositories/transfer_repository_impl.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../../domain/usecases/create_transfer_usecase.dart';

final transferLocalDataSourceProvider = Provider<TransferLocalDataSource>((
  ref,
) {
  return const TransferLocalDataSourceImpl();
});

final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  return TransferRepositoryImpl(
    localDataSource: ref.watch(transferLocalDataSourceProvider),
  );
});

final getTransferTypesUseCaseProvider = Provider<GetTransferTypesUseCase>((
  ref,
) {
  return GetTransferTypesUseCase(ref.watch(transferRepositoryProvider));
});
