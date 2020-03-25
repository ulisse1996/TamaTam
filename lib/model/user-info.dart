import 'package:json_annotation/json_annotation.dart';

part 'user-info.g.dart';

@JsonSerializable()
class UserInfo {

  UserInfo(this.userId, this.tamaId);

  String userId;
  String tamaId;

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

}