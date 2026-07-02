class SettingsEntity {
  const SettingsEntity({
    required this.notificationsEnabled,
    required this.languageCode,
  });

  final bool notificationsEnabled;
  final String languageCode;
}
