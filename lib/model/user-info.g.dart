// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user-info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
    json['userId'] as String,
    json['tamaId'] as String,
  );
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'userId': instance.userId,
      'tamaId': instance.tamaId,
    };
