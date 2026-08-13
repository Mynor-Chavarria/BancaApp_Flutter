import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/history_entity.dart';

class AccountTransactionModel {
  const AccountTransactionModel({
    required this.id,
    required this.date,
    required this.description,
    required this.type,
    required this.amount,
  });

  factory AccountTransactionModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    final rawDate = data['date'];
    return AccountTransactionModel(
      id: id,
      date:
          rawDate is Timestamp
              ? rawDate.toDate()
              : DateTime.tryParse(rawDate as String? ?? '') ?? DateTime.now(),
      description: data['description'] as String? ?? '',
      type: _transactionTypeFromString(data['type'] as String?),
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
    );
  }

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

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'date': Timestamp.fromDate(date),
      'description': description,
      'type': type.name,
      'amount': amount,
    };
  }

  static TransactionType _transactionTypeFromString(String? value) {
    return switch (value) {
      'credit' => TransactionType.credit,
      'debit' => TransactionType.debit,
      _ => TransactionType.debit,
    };
  }
}
