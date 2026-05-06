import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required int id,
    required String username,
    required String email,
    String? firstName,
    String? lastName,
    String? gender,
    String? image,
  }) = _UserProfile;
}
