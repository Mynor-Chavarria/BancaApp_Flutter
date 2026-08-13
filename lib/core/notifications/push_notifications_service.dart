import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../firebase/firestore_paths.dart';

class PushNotificationsService {
  const PushNotificationsService({
    required FirebaseMessaging messaging,
    required FirebaseFirestore firestore,
  }) : _messaging = messaging,
       _firestore = firestore;

  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;

  Future<void> registerDeviceForUser(String uid) async {
    await _messaging.requestPermission();
    final token = await _messaging.getToken();
    if (token == null || token.trim().isEmpty) {
      return;
    }

    await _saveToken(uid: uid, token: token);

    _messaging.onTokenRefresh.listen((newToken) {
      _saveToken(uid: uid, token: newToken);
    });
  }

  Future<void> _saveToken({required String uid, required String token}) async {
    await _firestore
        .collection(FirestorePaths.userFcmTokens(uid))
        .doc(token)
        .set({
          'token': token,
          'platform': 'android',
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }
}
