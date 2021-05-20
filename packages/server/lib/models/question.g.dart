// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return Question(
    json['category'] as String,
    _$enumDecode(_$QuestionDifficultyEnumMap, json['difficulty']),
    json['question'] as String,
    json['correct_answer'] as String,
    (json['incorrect_answers'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'category': instance.category,
      'difficulty': _$QuestionDifficultyEnumMap[instance.difficulty],
      'question': instance.question,
      'correct_answer': instance.correctAnswer,
      'incorrect_answers': instance.incorrectAnswers,
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
