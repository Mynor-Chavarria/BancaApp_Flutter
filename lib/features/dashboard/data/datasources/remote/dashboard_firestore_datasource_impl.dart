import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/errors/app_error.dart';
import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/firebase/firestore_paths.dart';
import '../../models/dashboard_account_model.dart';
import 'dashboard_firestore_datasource.dart';

class DashboardFirestoreDataSourceImpl implements DashboardFirestoreDataSource {
  const DashboardFirestoreDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<List<DashboardAccountModel>> getAccounts({required String uid}) async {
    try {
      final snapshot =
          await _firestore
              .collection(FirestorePaths.userAccounts(uid))
              .orderBy('productType')
              .get();

      return snapshot.docs
          .map(
            (doc) =>
                DashboardAccountModel.fromJson({'id': doc.id, ...doc.data()}),
          )
          .toList(growable: false);
    } on FirebaseException catch (error) {
      throw AppException(
        AppError(
          type: AppErrorType.unknown,
          message: _messageFromFirestoreError(
            error,
            action: 'leer las cuentas',
          ),
          details: error,
        ),
      );
    }
  }

  @override
  Future<void> seedAccounts({
    required String uid,
    required List<DashboardAccountModel> accounts,
  }) async {
    try {
      final batch = _firestore.batch();
      for (final account in accounts) {
        final reference = _firestore.doc(
          FirestorePaths.userAccount(uid, account.id),
        );
        batch.set(reference, {
          ...account.toFirestore(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } on FirebaseException catch (error) {
      throw AppException(
        AppError(
          type: AppErrorType.unknown,
          message: _messageFromFirestoreError(
            error,
            action: 'crear las cuentas',
          ),
          details: error,
        ),
      );
    }
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
