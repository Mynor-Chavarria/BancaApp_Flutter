import '../entities/transfer_entity.dart';

abstract class TransferRepository {
  Future<List<TransferTypeEntity>> getTransferTypes();
}
