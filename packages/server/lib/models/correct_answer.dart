import 'package:json_annotation/json_annotation.dart';
import 'package:kahootify_server/models/data.dart';

part 'correct_answer.g.dart';

@JsonSerializable()
class CorrectAnswer extends Data {
  int answer;

  CorrectAnswer(this.answer) : super(DataType.correctAnswer);

  factory CorrectAnswer.fromJson(Map<String, dynamic> json) => _$CorrectAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$CorrectAnswerToJson(this);
}
