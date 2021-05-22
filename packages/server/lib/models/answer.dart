import 'package:json_annotation/json_annotation.dart';
import 'package:kahootify_server/models/data.dart';

part 'answer.g.dart';

@JsonSerializable()
class Answer extends Data {
  final int answer;
  final String question;

  Answer(this.answer, this.question) : super(DataType.answer);

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}
