import '../../../domain/entities/history_entity.dart';
import '../../models/account_transaction_model.dart';
import 'history_local_datasource.dart';

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  const HistoryLocalDataSourceImpl();

  @override
  Future<List<AccountTransactionModel>> getTransactions(
    String accountId,
  ) async {
    final now = DateTime.now();
    DateTime d(int days) => now.subtract(Duration(days: days));

    final Map<String, List<AccountTransactionModel>> data = {
      '0101 2233 4455 6677': [
        AccountTransactionModel(
          id: 'TXN-001',
          date: d(1),
          description: 'Pago de electricidad',
          type: TransactionType.debit,
          amount: 245.50,
        ),
        AccountTransactionModel(
          id: 'TXN-002',
          date: d(2),
          description: 'Transferencia recibida – Ana Morales',
          type: TransactionType.credit,
          amount: 1500.00,
        ),
        AccountTransactionModel(
          id: 'TXN-003',
          date: d(4),
          description: 'Pago de agua',
          type: TransactionType.debit,
          amount: 89.00,
        ),
        AccountTransactionModel(
          id: 'TXN-004',
          date: d(6),
          description: 'Depósito nómina',
          type: TransactionType.credit,
          amount: 5200.00,
        ),
        AccountTransactionModel(
          id: 'TXN-005',
          date: d(8),
          description: 'Supermercado La Torre',
          type: TransactionType.debit,
          amount: 432.75,
        ),
        AccountTransactionModel(
          id: 'TXN-006',
          date: d(10),
          description: 'Recarga Tigo',
          type: TransactionType.debit,
          amount: 50.00,
        ),
        AccountTransactionModel(
          id: 'TXN-007',
          date: d(12),
          description: 'Transferencia a Juan López',
          type: TransactionType.debit,
          amount: 300.00,
        ),
        AccountTransactionModel(
          id: 'TXN-008',
          date: d(15),
          description: 'Pago de internet',
          type: TransactionType.debit,
          amount: 179.00,
        ),
        AccountTransactionModel(
          id: 'TXN-009',
          date: d(18),
          description: 'Intereses mensuales',
          type: TransactionType.credit,
          amount: 12.30,
        ),
        AccountTransactionModel(
          id: 'TXN-010',
          date: d(21),
          description: 'Farmacia Galeno',
          type: TransactionType.debit,
          amount: 155.25,
        ),
        AccountTransactionModel(
          id: 'TXN-011',
          date: d(25),
          description: 'Depósito en efectivo',
          type: TransactionType.credit,
          amount: 800.00,
        ),
        AccountTransactionModel(
          id: 'TXN-012',
          date: d(28),
          description: 'Pago de teléfono',
          type: TransactionType.debit,
          amount: 199.00,
        ),
      ],
      '0101 9988 7766 5544': [
        AccountTransactionModel(
          id: 'TXN-101',
          date: d(1),
          description: 'Abono mensual',
          type: TransactionType.credit,
          amount: 2000.00,
        ),
        AccountTransactionModel(
          id: 'TXN-102',
          date: d(3),
          description: 'Retiro cajero automático',
          type: TransactionType.debit,
          amount: 500.00,
        ),
        AccountTransactionModel(
          id: 'TXN-103',
          date: d(7),
          description: 'Transferencia recibida – Carlos Pérez',
          type: TransactionType.credit,
          amount: 750.00,
        ),
        AccountTransactionModel(
          id: 'TXN-104',
          date: d(9),
          description: 'Pago de seguro vehicular',
          type: TransactionType.debit,
          amount: 620.00,
        ),
        AccountTransactionModel(
          id: 'TXN-105',
          date: d(13),
          description: 'Intereses ahorro',
          type: TransactionType.credit,
          amount: 45.80,
        ),
        AccountTransactionModel(
          id: 'TXN-106',
          date: d(17),
          description: 'Restaurante El Rodeo',
          type: TransactionType.debit,
          amount: 285.00,
        ),
        AccountTransactionModel(
          id: 'TXN-107',
          date: d(22),
          description: 'Depósito nómina',
          type: TransactionType.credit,
          amount: 5200.00,
        ),
        AccountTransactionModel(
          id: 'TXN-108',
          date: d(27),
          description: 'Pago tarjeta de crédito',
          type: TransactionType.debit,
          amount: 1200.00,
        ),
      ],
    };

    return data[accountId] ?? [];
  }
}
