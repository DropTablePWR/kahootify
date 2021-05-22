// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) {
  return QuizQuestion(
    json['category'] as String,
    _$enumDecode(_$QuestionDifficultyEnumMap, json['difficulty']),
    json['question'] as String,
    (json['possibleAnswers'] as List<dynamic>).map((e) => e as String).toList(),
  )..dataType = _$enumDecode(_$DataTypeEnumMap, json['dataType']);
}

Map<String, dynamic> _$QuizQuestionToJson(QuizQuestion instance) => <String, dynamic>{
      'dataType': _$DataTypeEnumMap[instance.dataType],
      'category': instance.category,
      'difficulty': _$QuestionDifficultyEnumMap[instance.difficulty],
      'question': instance.question,
      'possibleAnswers': instance.possibleAnswers,
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

const _$QuestionDifficultyEnumMap = {
  QuestionDifficulty.easy: 'easy',
  QuestionDifficulty.medium: 'medium',
  QuestionDifficulty.hard: 'hard',
};

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
};
