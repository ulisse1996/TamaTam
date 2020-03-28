import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';

import '../common/common.dart';

part 'tama.g.dart';

enum TamaType {
  CAT,
  CHICK,
  FOX,
  MOUSE,
  PIG,
  RABBIT
}

@JsonSerializable()
class Tama {

  Tama(this.tamaId, this.tamaType, 
    this.life, this.food, this.happy, this.sleep,
    this.lifeTime);

  factory Tama.empty(String uuid) => Tama(uuid, randomType(), Decimal.one, Decimal.one,Decimal.one,Decimal.one, DateTime.now());

  static TamaType randomType() {
    return TamaType.values[Random().nextInt(TamaType.values.length - 1)];
  }

  String tamaId;
  TamaType tamaType;

  @JsonKey(fromJson: decimalDeserializer, toJson: decimalSerializer)
  Decimal life;
  @JsonKey(fromJson: decimalDeserializer, toJson: decimalSerializer)
  Decimal food;
  @JsonKey(fromJson: decimalDeserializer, toJson: decimalSerializer)
  Decimal happy;
  @JsonKey(fromJson: decimalDeserializer, toJson: decimalSerializer)
  Decimal sleep;
  DateTime lifeTime;

  factory Tama.fromJson(Map<String, dynamic> json) => _$TamaFromJson(json);

  Map<String, dynamic> toJson() => _$TamaToJson(this);

}