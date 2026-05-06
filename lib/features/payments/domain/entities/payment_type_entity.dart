class PaymentTypeEntity {
  const PaymentTypeEntity({
    required this.id,
    required this.labelKey,
    required this.iconCode,
  });

  final String id;
  final String labelKey;
  final int iconCode;
}
