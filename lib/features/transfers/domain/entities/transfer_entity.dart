class TransferTypeEntity {
  const TransferTypeEntity({
    required this.id,
    required this.labelKey,
    required this.iconCode,
  });

  final String id;

  /// Clave de localización para el nombre del tipo de transferencia.
  final String labelKey;

  /// Código del icono de Material Icons.
  final int iconCode;
}
