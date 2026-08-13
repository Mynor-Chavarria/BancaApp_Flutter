import '../../domain/entities/dashboard_entity.dart';

class DashboardAccountModel {
  const DashboardAccountModel({
    required this.id,
    required this.productType,
    required this.accountName,
    required this.accountNumber,
    required this.accountHolderName,
    required this.currency,
    required this.availableBalance,
    this.currentBalance,
    this.creditLimit,
    this.status = 'active',
  });

  factory DashboardAccountModel.fromJson(Map<String, dynamic> json) {
    final productType = (json['productType'] as num?)?.toInt() ?? 0;
    final currency = json['currency'] as String? ?? 'GTQ';
    final availableBalance =
        (json['availableBalance'] as num?)?.toDouble() ??
        (json['amountInQuetzales'] as num?)?.toDouble() ??
        0;

    return DashboardAccountModel(
      id: json['id'] as String? ?? json['accountNumber'] as String? ?? '',
      productType: productType,
      accountName:
          json['accountName'] as String? ?? _accountNameFromType(productType),
      accountNumber:
          json['accountNumber'] as String? ?? json['id'] as String? ?? '',
      accountHolderName: json['accountHolderName'] as String? ?? '',
      currency: currency,
      availableBalance: availableBalance,
      currentBalance: (json['currentBalance'] as num?)?.toDouble(),
      creditLimit: (json['creditLimit'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'active',
    );
  }

  final String id;
  final int productType;
  final String accountName;
  final String accountNumber;
  final String accountHolderName;
  final String currency;
  final double availableBalance;
  final double? currentBalance;
  final double? creditLimit;
  final String status;

  DashboardEntity toEntity() {
    return DashboardEntity(
      id: id,
      productType: productType,
      accountName: accountName,
      accountNumber: accountNumber,
      accountHolderName: accountHolderName,
      currency: currency,
      availableBalance: availableBalance,
      currentBalance: currentBalance,
      creditLimit: creditLimit,
      status: status,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'productType': productType,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'accountHolderName': accountHolderName,
      'currency': currency,
      'availableBalance': availableBalance,
      'currentBalance': currentBalance ?? availableBalance,
      'creditLimit': creditLimit,
      'status': status,
    };
  }

  DashboardAccountModel copyWith({
    String? id,
    int? productType,
    String? accountName,
    String? accountNumber,
    String? accountHolderName,
    String? currency,
    double? availableBalance,
    double? currentBalance,
    double? creditLimit,
    String? status,
  }) {
    return DashboardAccountModel(
      id: id ?? this.id,
      productType: productType ?? this.productType,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      currency: currency ?? this.currency,
      availableBalance: availableBalance ?? this.availableBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      creditLimit: creditLimit ?? this.creditLimit,
      status: status ?? this.status,
    );
  }

  static String _accountNameFromType(int productType) {
    return switch (productType) {
      3 => 'accountMonetary',
      4 => 'accountSaving',
      20 => 'creditCard',
      _ => 'account',
    };
  }
}
