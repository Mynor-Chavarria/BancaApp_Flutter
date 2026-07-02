class DashboardUserModel {
  const DashboardUserModel({required this.fullName});

  factory DashboardUserModel.fromJson(Map<String, dynamic> json) {
    final firstName = (json['firstName'] as String?)?.trim() ?? '';
    final lastName = (json['lastName'] as String?)?.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();

    return DashboardUserModel(fullName: fullName);
  }

  final String fullName;
}
