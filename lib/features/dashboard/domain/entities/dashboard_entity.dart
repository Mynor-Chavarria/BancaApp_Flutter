class DashboardEntity {
  const DashboardEntity({
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

  double get amountInQuetzales => availableBalance;
}
