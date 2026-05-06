class DashboardEntity {
  const DashboardEntity({
    required this.accountName,
    required this.accountNumber,
    required this.accountHolderName,
    required this.amountInQuetzales,
  });

  final String accountName;
  final String accountNumber;
  final String accountHolderName;
  final double amountInQuetzales;
}
