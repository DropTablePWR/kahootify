// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerInfo _$ServerInfoFromJson(Map<String, dynamic> json) {
  return ServerInfo(
    ip: json['ip'] as String,
    name: json['name'] as String,
    maxNumberOfPlayers: json['maxNumberOfPlayers'] as int,
    currentNumberOfPlayers: json['currentNumberOfPlayers'] as int,
    serverStatus: _$enumDecode(_$ServerStatusEnumMap, json['serverStatus']),
  )..dataType = _$enumDecode(_$DataTypeEnumMap, json['dataType']);
}

Map<String, dynamic> _$ServerInfoToJson(ServerInfo instance) => <String, dynamic>{
      'dataType': _$DataTypeEnumMap[instance.dataType],
      'ip': instance.ip,
      'name': instance.name,
      'maxNumberOfPlayers': instance.maxNumberOfPlayers,
      'currentNumberOfPlayers': instance.currentNumberOfPlayers,
      'serverStatus': _$ServerStatusEnumMap[instance.serverStatus],
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

const _$ServerStatusEnumMap = {
  ServerStatus.lobby: 'lobby',
  ServerStatus.inGame: 'inGame',
  ServerStatus.results: 'results',
};

const _$DataTypeEnumMap = {
  DataType.serverInfo: 'serverInfo',
  DataType.playerInfo: 'playerInfo',
  DataType.unknown: 'unknown',
  DataType.error: 'error',
  DataType.playersInfo: 'playersInfo',
};
