import 'package:flutter/material.dart';

import '../../models/transfer_type_model.dart';
import 'transfer_local_datasource.dart';

class TransferLocalDataSourceImpl implements TransferLocalDataSource {
  const TransferLocalDataSourceImpl();

  @override
  Future<List<TransferTypeModel>> getTransferTypes() async {
    return [
      TransferTypeModel(
        id: 'third_party',
        labelKey: 'transferThirdParty',
        iconCode: Icons.people_outlined.codePoint,
      ),
      TransferTypeModel(
        id: 'own',
        labelKey: 'transferOwn',
        iconCode: Icons.account_balance_wallet_outlined.codePoint,
      ),
      TransferTypeModel(
        id: 'ach',
        labelKey: 'transferACH',
        iconCode: Icons.account_balance_outlined.codePoint,
      ),
      TransferTypeModel(
        id: 'international',
        labelKey: 'transferInternational',
        iconCode: Icons.language_outlined.codePoint,
      ),
    ];
  }
}
