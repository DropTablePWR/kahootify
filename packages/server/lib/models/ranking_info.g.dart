// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RankingInfo _$RankingInfoFromJson(Map<String, dynamic> json) {
  return RankingInfo(
    (json['players'] as List<dynamic>).map((e) => PlayerInfo.fromJson(e as Map<String, dynamic>)).toList(),
  )..dataType = _$enumDecode(_$DataTypeEnumMap, json['dataType']);
}

Map<String, dynamic> _$RankingInfoToJson(RankingInfo instance) => <String, dynamic>{
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
  DataType.playerListInfo: 'playerListInfo',
  DataType.gameStarted: 'gameStarted',
  DataType.startGame: 'startGame',
  DataType.question: 'question',
  DataType.answer: 'answer',
  DataType.rankingStarted: 'rankingStarted',
  DataType.lobbyStarted: 'lobbyStarted',
  DataType.returnToLobby: 'returnToLobby',
  DataType.goodbye: 'goodbye',
};
