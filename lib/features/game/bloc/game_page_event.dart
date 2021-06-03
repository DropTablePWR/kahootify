import 'package:kahootify_server/models/correct_answer.dart';
import 'package:kahootify_server/models/quiz_question.dart';
import 'package:kahootify_server/models/ranking_info.dart';

abstract class GamePageEvent {}

class ReceivedRanking extends GamePageEvent {
  final RankingInfo rankingInfo;

  ReceivedRanking(this.rankingInfo);
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

class ReceivedCorrectAnswer extends GamePageEvent {
  final CorrectAnswer correctAnswer;

  ReceivedCorrectAnswer(this.correctAnswer);
}
