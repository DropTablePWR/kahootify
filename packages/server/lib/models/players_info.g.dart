// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'players_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayersInfo _$PlayersInfoFromJson(Map<String, dynamic> json) {
  return PlayersInfo(
    (json['players'] as List<dynamic>).map((e) => PlayerInfo.fromJson(e as Map<String, dynamic>)).toList(),
  )..dataType = _$enumDecode(_$DataTypeEnumMap, json['dataType']);
}

Map<String, dynamic> _$PlayersInfoToJson(PlayersInfo instance) => <String, dynamic>{
      'dataType': _$DataTypeEnumMap[instance.dataType],
      'players': instance.players,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$DataTypeEnumMap = {
  DataType.serverInfo: 'serverInfo',
  DataType.playerInfo: 'playerInfo',
  DataType.unknown: 'unknown',
  DataType.error: 'error',
  DataType.playersInfo: 'playersInfo',
};
