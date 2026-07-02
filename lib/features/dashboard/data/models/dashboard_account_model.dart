import '../../domain/entities/dashboard_entity.dart';

class DashboardAccountModel {
  const DashboardAccountModel({
    required this.accountName,
    required this.accountNumber,
    required this.accountHolderName,
    required this.amountInQuetzales,
  });

  factory DashboardAccountModel.fromJson(Map<String, dynamic> json) {
    return DashboardAccountModel(
      accountName: json['accountName'] as String? ?? '',
      accountNumber: json['accountNumber'] as String? ?? '',
      accountHolderName: json['accountHolderName'] as String? ?? '',
      amountInQuetzales: (json['amountInQuetzales'] as num?)?.toDouble() ?? 0,
    );
  }

  final String accountName;
  final String accountNumber;
  final String accountHolderName;
  final double amountInQuetzales;

  DashboardEntity toEntity() {
    return DashboardEntity(
      accountName: accountName,
      accountNumber: accountNumber,
      accountHolderName: accountHolderName,
      amountInQuetzales: amountInQuetzales,
    );
  }

  DashboardAccountModel copyWith({
    String? accountName,
    String? accountNumber,
    String? accountHolderName,
    double? amountInQuetzales,
  }) {
    return DashboardAccountModel(
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      amountInQuetzales: amountInQuetzales ?? this.amountInQuetzales,
    );
  }
}
