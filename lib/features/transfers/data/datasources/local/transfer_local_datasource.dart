import '../../models/transfer_type_model.dart';

abstract class TransferLocalDataSource {
  Future<List<TransferTypeModel>> getTransferTypes();
}
