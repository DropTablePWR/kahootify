import 'package:kahootify_server/models/answer.dart';
import 'package:kahootify_server/models/error_info.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/question.dart';
import 'package:kahootify_server/models/quiz_question.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:kahootify_server/players/abstract_player.dart';
import 'package:kahootify_server/server.dart';
import 'package:kahootify_server/server_modes/server_mode.dart';

class GameMode extends ServerMode {
  int currentQuestion = 0;
  List<Question> questions;
  Map<AbstractPlayer, AnswerTimestamp> answers = {};

  GameMode(Server server, this.questions) : super(server) {
    this.run();
    print("wow");
  }

  @override
  ServerMode nextMode() {
    // TODO: implement nextMode
    print("End of game");
    return this;
  }

  void run() async {
    var delay = Duration(seconds: 3);
    for (Question question in questions) {
      answers = {};
      var sentQuestion = QuizQuestion.fromQuestion(question: question);
      this.server.sendDataToAll(sentQuestion.toJson());
      var timestamp = DateTime.now();
      // wait x seconds
      await Future.delayed(Duration(seconds: this.server.serverInfo.answerTimeLimit));
      _calculatePoints(sentQuestion, question, timestamp, delay);
    }
    nextMode();
  }

  void _calculatePoints(QuizQuestion quizQuestion, Question question, DateTime sentTimestamp, Duration delay) {
    // final timeEnd = DateTime.now();
    // final timeStart = sentTimestamp.add(delay);
    //  TODO Calculate points
  }

  @override
  void handlePlayerInfo(PlayerInfo playerInfo, AbstractPlayer player) {
    _sendInvalidOperation(player);
  }

  @override
  void handleServerInfo(ServerInfo serverInfo, AbstractPlayer player) {
    _sendInvalidOperation(player);
  }

  @override
  void handleStartGame(AbstractPlayer player) {
    _sendInvalidOperation(player);
  }

  void _sendInvalidOperation(AbstractPlayer player) {
    player.send(ErrorInfo("Operation invalid during game mode").toJson());
  }

  @override
  void handleAnswer(Answer answer, AbstractPlayer player) {
    var preparedAnswer = AnswerTimestamp.fromAnswer(answer, player);
    answers[player] = preparedAnswer;
  }
}

class AnswerTimestamp extends Answer {
  final DateTime timestamp;
  final AbstractPlayer abstractPlayer;

  AnswerTimestamp(int answer, String question, AbstractPlayer abstractPlayer)
      : this.timestamp = DateTime.now(),
        this.abstractPlayer = abstractPlayer,
        super(answer, question);

  AnswerTimestamp.fromAnswer(Answer answer, AbstractPlayer abstractPlayer)
      : this.timestamp = DateTime.now(),
        this.abstractPlayer = abstractPlayer,
        super(answer.answer, answer.question);
}
