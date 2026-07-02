import '../../domain/entities/history_entity.dart';

class AccountTransactionModel {
  const AccountTransactionModel({
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

  AccountTransactionEntity toEntity() => AccountTransactionEntity(
    id: id,
    date: date,
    description: description,
    type: type,
    amount: amount,
  );
}
