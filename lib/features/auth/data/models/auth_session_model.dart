import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_session.dart';

part 'auth_session_model.freezed.dart';
part 'auth_session_model.g.dart';

@freezed
abstract class AuthSessionModel with _$AuthSessionModel {
  const factory AuthSessionModel({
    required String uid,
    required int id,
    required String username,
    required String email,
    required String accessToken,
    required String refreshToken,
    String? firstName,
    String? lastName,
    String? image,
    String? gender,
  }) = _AuthSessionModel;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionModelFromJson(json);
}

extension AuthSessionModelMapper on AuthSessionModel {
  AuthSession toEntity() {
    return AuthSession(
      userId: id,
      uid: uid,
      username: username,
      email: email,
      accessToken: accessToken,
      refreshToken: refreshToken,
      firstName: firstName,
      lastName: lastName,
      image: image,
      gender: gender,
    );
  }
}

extension AuthSessionEntityMapper on AuthSession {
  AuthSessionModel toModel() {
    return AuthSessionModel(
      id: userId,
      uid: uid,
      username: username,
      email: email,
      accessToken: accessToken,
      refreshToken: refreshToken,
      firstName: firstName,
      lastName: lastName,
      image: image,
      gender: gender,
    );
  }
}
