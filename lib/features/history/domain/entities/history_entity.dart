enum TransactionType { credit, debit }

class AccountTransactionEntity {
  const AccountTransactionEntity({
    required this.id,
    required this.date,
    required this.description,
    required this.type,
    required this.amount,
  });

  final String id;
  final DateTime date;
  final String description;
  final TransactionType type;
  final double amount;
}
