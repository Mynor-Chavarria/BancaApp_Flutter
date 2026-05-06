import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required int id,
    required String username,
    required String email,
    String? firstName,
    String? lastName,
    String? gender,
    String? image,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

extension UserProfileModelMapper on UserProfileModel {
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      image: image,
    );
  }
}
