import '../entities/transfer_entity.dart';
import '../repositories/transfer_repository.dart';

class GetTransferTypesUseCase {
  const GetTransferTypesUseCase(this._repository);

  final TransferRepository _repository;

  Future<List<TransferTypeEntity>> call() {
    return _repository.getTransferTypes();
  }
}
