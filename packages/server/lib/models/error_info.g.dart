// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorInfo _$ErrorInfoFromJson(Map<String, dynamic> json) {
  return ErrorInfo(
    json['message'] as String,
  )..dataType = _$enumDecode(_$DataTypeEnumMap, json['dataType']);
}

Map<String, dynamic> _$ErrorInfoToJson(ErrorInfo instance) => <String, dynamic>{
      'dataType': _$DataTypeEnumMap[instance.dataType],
      'message': instance.message,
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
};
