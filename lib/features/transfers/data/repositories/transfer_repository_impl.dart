import '../../domain/entities/transfer_entity.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../datasources/local/transfer_local_datasource.dart';

class TransferRepositoryImpl implements TransferRepository {
  const TransferRepositoryImpl({
    required TransferLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  final TransferLocalDataSource _localDataSource;

  @override
  Future<List<TransferTypeEntity>> getTransferTypes() async {
    final models = await _localDataSource.getTransferTypes();
    return models.map((m) => m.toEntity()).toList(growable: false);
  }
}
