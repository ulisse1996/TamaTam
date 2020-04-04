import 'package:json_annotation/json_annotation.dart';

import '../common/common.dart';

part 'user-info.g.dart';

// Define a UserInfo Entity
@JsonSerializable()
class UserInfo extends BaseModel{

  UserInfo(this.userId, this.tamaId, this.lastLogin);

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  String userId;
  String tamaId;
  DateTime lastLogin;

  @override
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}