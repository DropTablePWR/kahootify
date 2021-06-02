import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/quiz_question.dart';

abstract class GamePageEvent {}

class ReceivedRanking extends GamePageEvent {
  final List<PlayerInfo> results;

  ReceivedRanking(this.results);
}

class ShowQuestion extends GamePageEvent {}

class ReceivedQuestion extends GamePageEvent {
  final QuizQuestion quizQuestion;

  ReceivedQuestion(this.quizQuestion);
}

class AnswerQuestion extends GamePageEvent {
  final int chosenAnswerIndex;

  AnswerQuestion(this.chosenAnswerIndex);
}

class ProceedToResultsScreen extends GamePageEvent {}
