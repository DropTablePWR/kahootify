import 'package:json_annotation/json_annotation.dart';
import 'package:kahootify_server/models/data.dart';
import 'package:kahootify_server/models/question.dart';

part 'quiz_question.g.dart';

@JsonSerializable()
class QuizQuestion extends Data {
  final String category;
  final QuestionDifficulty difficulty;
  final String question;
  final List<String> possibleAnswers;

  QuizQuestion(this.category, this.difficulty, this.question, this.possibleAnswers) : super(DataType.question);

  QuizQuestion.fromQuestion({required Question question})
      : this.category = question.category,
        this.difficulty = question.difficulty,
        this.question = question.question,
        this.possibleAnswers = []
          ..addAll(question.incorrectAnswers)
          ..add(question.correctAnswer)
          ..shuffle(),
        super(DataType.question);

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => _$QuizQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuizQuestionToJson(this);
}
