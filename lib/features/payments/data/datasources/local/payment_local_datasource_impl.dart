import 'package:flutter/material.dart';

import '../../models/payment_type_model.dart';
import 'payment_local_datasource.dart';

class PaymentLocalDataSourceImpl implements PaymentLocalDataSource {
  const PaymentLocalDataSourceImpl();

  @override
  Future<List<PaymentTypeModel>> getPaymentTypes() async {
    return [
      PaymentTypeModel(
        id: 'service_payment',
        labelKey: 'paymentServicePayment',
        iconCode: Icons.receipt_long_outlined.codePoint,
      ),
      PaymentTypeModel(
        id: 'mobile_recharge',
        labelKey: 'paymentMobileRecharge',
        iconCode: Icons.smartphone_outlined.codePoint,
      ),
    ];
  }
}
