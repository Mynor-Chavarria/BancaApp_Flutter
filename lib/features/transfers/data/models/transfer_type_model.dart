import '../../domain/entities/transfer_entity.dart';

class TransferTypeModel {
  const TransferTypeModel({
    required this.id,
    required this.labelKey,
    required this.iconCode,
  });

  factory TransferTypeModel.fromJson(Map<String, dynamic> json) {
    return TransferTypeModel(
      id: json['id'] as String,
      labelKey: json['labelKey'] as String,
      iconCode: json['iconCode'] as int,
    );
  }

  final String id;
  final String labelKey;
  final int iconCode;

  TransferTypeEntity toEntity() {
    return TransferTypeEntity(id: id, labelKey: labelKey, iconCode: iconCode);
  }
}
