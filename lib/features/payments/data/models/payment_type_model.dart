import '../../domain/entities/payment_type_entity.dart';

class PaymentTypeModel {
  const PaymentTypeModel({
    required this.id,
    required this.labelKey,
    required this.iconCode,
  });

  final String id;
  final String labelKey;
  final int iconCode;

  PaymentTypeEntity toEntity() =>
      PaymentTypeEntity(id: id, labelKey: labelKey, iconCode: iconCode);
}
