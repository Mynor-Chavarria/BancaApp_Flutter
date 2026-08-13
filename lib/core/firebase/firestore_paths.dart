class FirestorePaths {
  const FirestorePaths._();

  static String user(String uid) => 'users/$uid';

  static String userAccounts(String uid) => '${user(uid)}/accounts';

  static String userAccount(String uid, String accountId) =>
      '${userAccounts(uid)}/$accountId';

  static String accountMovements(String uid, String accountId) =>
      '${userAccount(uid, accountId)}/movements';

  static String userFcmTokens(String uid) => '${user(uid)}/fcmTokens';
}
