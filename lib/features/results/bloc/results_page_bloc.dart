import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify_server/models/data.dart';
import 'package:kahootify_server/models/ranking_info.dart';

class ResultsPageBloc extends Bloc<ResultsPageEvent, ResultsPageState> {
  ResultsPageBloc({required this.serverOutput, required this.serverInput}) : super(ResultsPageState()) {
    serverOutput.listen((receivedData) {
      var decodedData = jsonDecode(receivedData);
      var data = Data.fromJson(decodedData);
      switch (data.dataType) {
        case DataType.rankingInfo:
          add(ReceivedRankingInfo(RankingInfo.fromJson(decodedData)));
          break;
        case DataType.lobbyStarted:
          add(ReceivedBackToLobby());
          break;
        case DataType.serverInfo:
        case DataType.playerInfo:
        case DataType.unknown:
        case DataType.error:
        case DataType.playerListInfo:
        case DataType.gameStarted:
        case DataType.startGame:
        case DataType.quizQuestion:
        case DataType.answer:
        case DataType.rankingStarted:
        case DataType.returnToLobby:
        case DataType.goodbye:
        case DataType.readyToBeKilled:
        case DataType.correctAnswer:
          print('results page unsupported data: ${data.dataType}');
      }
    });
  }

  final Stream serverOutput;
  final StreamController serverInput;

  @override
  Stream<ResultsPageState> mapEventToState(ResultsPageEvent event) async* {
    if (event is ReceivedBackToLobby) {
      yield state.goBackToLobby();
    } else if (event is ReceivedRankingInfo) {
      yield ResultsPageState(rankingInfo: event.rankingInfo);
    } else if (event is SendBackToLobby) {
      serverInput.add(jsonEncode(Data(DataType.returnToLobby)));
    }
  }
}

abstract class ResultsPageEvent {}

class SendBackToLobby extends ResultsPageEvent {}

class ReceivedBackToLobby extends ResultsPageEvent {}

class ReceivedRankingInfo extends ResultsPageEvent {
  final RankingInfo rankingInfo;

  ReceivedRankingInfo(this.rankingInfo);
}

class ResultsPageState {
  final RankingInfo? rankingInfo;
  final bool shouldGoBackToLobby;

  ResultsPageState({this.rankingInfo, this.shouldGoBackToLobby = false});

  ResultsPageState goBackToLobby() {
    return ResultsPageState(rankingInfo: rankingInfo, shouldGoBackToLobby: true);
  }
}
