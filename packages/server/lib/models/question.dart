import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  final String category;
  final QuestionDifficulty difficulty;
  final String question;
  @JsonKey(name: 'correct_answer')
  final String correctAnswer;
  @JsonKey(name: 'incorrect_answers')
  final List<String> incorrectAnswers;

  Question(this.category, this.difficulty, this.question, this.correctAnswer, this.incorrectAnswers);

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

enum QuestionDifficulty { easy, medium, hard }
