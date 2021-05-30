import 'package:kahootify_server/models/answer.dart';
import 'package:kahootify_server/models/data.dart';
import 'package:kahootify_server/models/error_info.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/question.dart';
import 'package:kahootify_server/models/quiz_question.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:kahootify_server/players/abstract_player.dart';
import 'package:kahootify_server/server.dart';
import 'package:kahootify_server/server_modes/lobby_mode.dart';
import 'package:kahootify_server/server_modes/ranking_mode.dart';
import 'package:kahootify_server/server_modes/server_mode.dart';

class GameMode extends ServerMode {
  int currentQuestion = 0;
  List<Question> questions;
  Map<AbstractPlayer, AnswerTimestamp> answers = {};
  bool gameIsActive = true;

  GameMode(Server server, this.questions) : super(server) {
    print("Server is in Game Mode");
    server.sendDataToAll(Data(DataType.gameStarted).toJson());
    this.run();
  }

  @override
  void nextMode() {
    server.serverMode = RankingMode(server);
  }

  void run() async {
    var delay = Duration(seconds: 3);
    for (Question question in questions) {
      if (!gameIsActive) {
        return;
      }
      answers = {};
      var sentQuestion = QuizQuestion.fromQuestion(question: question);
      this.server.sendDataToAll(sentQuestion.toJson());
      var timestamp = DateTime.now();
      // wait x seconds
      await Future.delayed(Duration(seconds: this.server.serverInfo.answerTimeLimit));
      _calculatePoints(sentQuestion, question, timestamp, delay);
      server.sendDataToAll(server.generateRankingInfo().toJson());
    }
    nextMode();
  }

  void _calculatePoints(QuizQuestion quizQuestion, Question question, DateTime sentTimestamp, Duration delay) {
    final timeEnd = DateTime.now();
    final timeStart = sentTimestamp.add(delay);
    final int difficulty;

    switch (question.difficulty) {
      case QuestionDifficulty.easy:
        difficulty = 1;
        break;
      case QuestionDifficulty.medium:
        difficulty = 2;
        break;
      case QuestionDifficulty.hard:
        difficulty = 3;
        break;
    }

    final validAnswer = quizQuestion.possibleAnswers.indexOf(question.correctAnswer);
    final answerDelta = timeEnd.difference(timeStart).inMilliseconds;

    for (AbstractPlayer player in server.knownPlayers.values) {
      final info = player.playerInfo;
      final answer = answers[player];

      if (answer != null && question.correctAnswer.compareTo(answer.question) == 0 && answer.answer == validAnswer) {
        final playerDelta = answer.timestamp.difference(timeStart).inMilliseconds;

        info.combo += 1;
        info.score += difficulty + info.combo * (answerDelta - playerDelta) / (answerDelta * 2);

        if (questions.length == info.combo) {
          info.score += 15;
        }
      } else {
        info.combo = 0;
      }
    }
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

  @override
  void returnToLobby() {
    gameIsActive = false;
    server.serverMode = LobbyMode(server);
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
