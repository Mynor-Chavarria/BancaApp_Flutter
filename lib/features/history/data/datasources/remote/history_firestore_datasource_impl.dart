import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/errors/app_error.dart';
import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/firebase/firestore_paths.dart';
import '../../models/account_transaction_model.dart';
import 'history_firestore_datasource.dart';

class HistoryFirestoreDataSourceImpl implements HistoryFirestoreDataSource {
  const HistoryFirestoreDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<List<AccountTransactionModel>> getTransactions({
    required String uid,
    required String accountId,
  }) async {
    try {
      final normalizedAccountId = _normalizeAccountId(accountId);
      final snapshot =
          await _firestore
              .collection(
                FirestorePaths.accountMovements(uid, normalizedAccountId),
              )
              .orderBy('date', descending: true)
              .get();

      return snapshot.docs
          .map(
            (doc) => AccountTransactionModel.fromFirestore(doc.id, doc.data()),
          )
          .toList(growable: false);
    } on FirebaseException catch (error) {
      throw AppException(
        AppError(
          type: AppErrorType.unknown,
          message: _messageFromFirestoreError(
            error,
            action: 'leer los movimientos',
          ),
          details: error,
        ),
      );
    }
  }

  @override
  Future<List<AccountTransactionModel>> getTransactionsPage({
    required String uid,
    required String accountId,
    required int limit,
    AccountTransactionModel? startAfter,
  }) async {
    try {
      final normalizedAccountId = _normalizeAccountId(accountId);
      Query<Map<String, dynamic>> query = _firestore
          .collection(FirestorePaths.accountMovements(uid, normalizedAccountId))
          .orderBy('date', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfter([Timestamp.fromDate(startAfter.date)]);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map(
            (doc) => AccountTransactionModel.fromFirestore(doc.id, doc.data()),
          )
          .toList(growable: false);
    } on FirebaseException catch (error) {
      throw AppException(
        AppError(
          type: AppErrorType.unknown,
          message: _messageFromFirestoreError(
            error,
            action: 'leer los movimientos paginados',
          ),
          details: error,
        ),
      );
    }
  }

  @override
  Future<void> seedTransactions({
    required String uid,
    required String accountId,
    required List<AccountTransactionModel> transactions,
  }) async {
    try {
      final normalizedAccountId = _normalizeAccountId(accountId);
      final batch = _firestore.batch();

      for (final transaction in transactions) {
        final reference = _firestore
            .collection(
              FirestorePaths.accountMovements(uid, normalizedAccountId),
            )
            .doc(transaction.id);
        batch.set(reference, {
          ...transaction.toFirestore(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } on FirebaseException catch (error) {
      throw AppException(
        AppError(
          type: AppErrorType.unknown,
          message: _messageFromFirestoreError(
            error,
            action: 'crear los movimientos',
          ),
          details: error,
        ),
      );
    }
  }

  String _normalizeAccountId(String accountId) {
    return accountId.replaceAll(RegExp(r'\s+'), '');
  }

  String _messageFromFirestoreError(
    FirebaseException error, {
    required String action,
  }) {
    final detail = error.message?.trim();
    final suffix =
        detail == null || detail.isEmpty
            ? error.code
            : '${error.code}: $detail';

    return 'No fue posible $action en Firestore. ($suffix)';
  }
}
