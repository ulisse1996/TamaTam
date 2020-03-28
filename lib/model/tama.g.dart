// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tama.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tama _$TamaFromJson(Map<String, dynamic> json) {
  return Tama(
    json['tamaId'] as String,
    _$enumDecodeNullable(_$TamaTypeEnumMap, json['tamaType']),
    decimalDeserializer(json['life']),
    decimalDeserializer(json['food']),
    decimalDeserializer(json['happy']),
    decimalDeserializer(json['sleep']),
    json['lifeTime'] == null
        ? null
        : DateTime.parse(json['lifeTime'] as String),
  );
}

Map<String, dynamic> _$TamaToJson(Tama instance) => <String, dynamic>{
      'tamaId': instance.tamaId,
      'tamaType': _$TamaTypeEnumMap[instance.tamaType],
      'life': decimalSerializer(instance.life),
      'food': decimalSerializer(instance.food),
      'happy': decimalSerializer(instance.happy),
      'sleep': decimalSerializer(instance.sleep),
      'lifeTime': instance.lifeTime?.toIso8601String(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$TamaTypeEnumMap = {
  TamaType.CAT: 'CAT',
  TamaType.CHICK: 'CHICK',
  TamaType.FOX: 'FOX',
  TamaType.MOUSE: 'MOUSE',
  TamaType.PIG: 'PIG',
  TamaType.RABBIT: 'RABBIT',
};
