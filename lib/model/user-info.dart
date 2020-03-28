import 'package:json_annotation/json_annotation.dart';

part 'user-info.g.dart';

@JsonSerializable()
class UserInfo {

  UserInfo(this.userId, this.tamaId);

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  String userId;
  String tamaId;

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

}