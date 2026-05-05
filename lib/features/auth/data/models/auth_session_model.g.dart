// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthSessionModelImpl _$$AuthSessionModelImplFromJson(
  Map<String, dynamic> json,
) => _$AuthSessionModelImpl(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  email: json['email'] as String,
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$$AuthSessionModelImplToJson(
  _$AuthSessionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'image': instance.image,
};
