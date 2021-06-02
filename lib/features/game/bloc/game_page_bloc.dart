import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify_server/models/answer.dart';
import 'package:kahootify_server/models/data.dart';
import 'package:kahootify_server/models/quiz_question.dart';
import 'package:kahootify_server/models/server_info.dart';

import 'bloc.dart';
import 'game_page_state.dart';

class GamePageBloc extends Bloc<GamePageEvent, GamePageState> {
  GamePageBloc({
    required ServerInfo serverInfo,
    required this.serverOutput,
    required this.serverInput,
  }) : super(GamePageState.initial(serverInfo: serverInfo)) {
    serverOutput.listen((receivedData) {
      var decodedData = jsonDecode(receivedData);
      var data = Data.fromJson(decodedData);
      switch (data.dataType) {
        case DataType.quizQuestion:
          add(ReceivedQuestion(QuizQuestion.fromJson(decodedData)));
          break;
        case DataType.rankingInfo:
          add(ProceedToResultsScreen());
          break;
        case DataType.playerListInfo:
        case DataType.serverInfo:
        case DataType.playerInfo:
        case DataType.unknown:
        case DataType.error:
        case DataType.gameStarted:
        case DataType.startGame:
        case DataType.answer:
        case DataType.lobbyStarted:
        case DataType.returnToLobby:
        case DataType.goodbye:
        case DataType.readyToBeKilled:
          print('Unsupported data: ${data.dataType}');
          break;
      }
    });
  }

  final Stream serverOutput;
  final StreamController serverInput;

  @override
  Stream<GamePageState> mapEventToState(GamePageEvent event) async* {
    if (event is ReceivedQuestion) {
      yield state.nextQuestion(quizQuestion: event.quizQuestion);
    } else if (event is ReceivedRanking) {
      yield state.copyWith(results: event.results, currentPage: 3);
    } else if (event is ProceedToResultsScreen) {
      yield state.proceedToNextScreen();
    } else if (event is ShowQuestion) {
      yield state.copyWith(currentPage: 2);
    } else if (event is AnswerQuestion) {
      serverInput.add(jsonEncode(Answer(event.chosenAnswerIndex, state.quizQuestion!.question).toJson()));
      yield state.chooseAnswer(event.chosenAnswerIndex);
    } else if (event is ReceivedCorrectAnswer) {
      yield state.correctAnswer(correctAnswerIndex: event.correctAnswerIndex);
    } else if (event is StartGame) {
      yield state.copyWith(currentPage: 1);
    }
  }
}
