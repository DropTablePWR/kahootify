import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify_server/models/data.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';

class LobbyPageBloc extends Bloc<LobbyPageEvent, LobbyPageState> {
  LobbyPageBloc({
    required PlayerInfo playerInfo,
    required ServerInfo serverInfo,
    required this.amIHost,
    required this.serverOutput,
    required this.serverInput,
  }) : super(LobbyPageState(playerInfo: playerInfo, playerList: [], serverInfo: serverInfo)) {
    serverOutput.listen((receivedData) => processServerData(receivedData));
  }

  final Stream serverOutput;
  final StreamController serverInput;
  final bool amIHost;

  void processServerData(receivedData) {
    var decodedData = jsonDecode(receivedData);
    var decodedDataType = DataType.values.firstWhere((element) => element.toString().split('.')[1] == decodedData['dataType']);
    switch (decodedDataType) {
      case DataType.playerListInfo:
        final newPlayerList = List<PlayerInfo>.from(decodedData['players'].map((rawPlayer) => PlayerInfo.fromJson(rawPlayer)).toList());
        add(ReceivedNewPlayerList(newPlayerList));
        break;
      case DataType.gameStarted:
        add(ReceivedGameStart());
        break;
      case DataType.serverInfo:
        add(ReceivedServerInfo(ServerInfo.fromJson(decodedData)));
        break;
      case DataType.startGame:
      case DataType.question:
      case DataType.answer:
      case DataType.rankingStarted:
      case DataType.lobbyStarted:
      case DataType.playerInfo:
      case DataType.unknown:
      case DataType.error:
      case DataType.returnToLobby:
      case DataType.goodbye:
      case DataType.readyToBeKilled:
        print('unsupported data: $decodedDataType');
        break;
    }
  }

  @override
  Stream<LobbyPageState> mapEventToState(LobbyPageEvent event) async* {
    if (event is IAmReadyButtonPressed) {
      if (amIHost && isGameReadyToStart(state.playerList)) {
        serverInput.add(jsonEncode(Data(DataType.startGame)));
      } else {
        final newReadyState = !state.playerInfo.ready;
        final newPlayerInfo = state.playerInfo.copyWith(ready: newReadyState);
        yield state.copyWith(playerInfo: newPlayerInfo);
        serverInput.add(jsonEncode(newPlayerInfo));
      }
    } else if (event is ReceivedNewPlayerList) {
      final newPlayerList = event.playerList;
      final isStartGameButtonVisible = isGameReadyToStart(newPlayerList);
      yield state.copyWith(playerList: newPlayerList, isStartGameButtonVisible: isStartGameButtonVisible);
    } else if (event is ReceivedGameStart) {
      yield state.copyWith(shouldProceedToGameScreen: true);
    } else if (event is ReceivedServerInfo) {
      yield state.copyWith(serverInfo: event.serverInfo);
    }
  }

  bool isGameReadyToStart(List<PlayerInfo> playerList) => isEveryoneReady(playerList) && playerList.length > 1;

  bool isEveryoneReady(List<PlayerInfo> playerList) => playerList.every((element) => element.ready);
}

abstract class LobbyPageEvent {}

class IAmReadyButtonPressed extends LobbyPageEvent {}

class ReceivedNewPlayerList extends LobbyPageEvent {
  final List<PlayerInfo> playerList;

  ReceivedNewPlayerList(this.playerList);
}

class ReceivedServerInfo extends LobbyPageEvent {
  final ServerInfo serverInfo;

  ReceivedServerInfo(this.serverInfo);
}

class ReceivedGameStart extends LobbyPageEvent {}

class LobbyPageState {
  final PlayerInfo playerInfo;
  final List<PlayerInfo> playerList;
  final bool isStartGameButtonVisible;
  final ServerInfo serverInfo;
  final bool shouldProceedToGameScreen;

  LobbyPageState({
    required this.playerInfo,
    required this.playerList,
    this.isStartGameButtonVisible = false,
    required this.serverInfo,
    this.shouldProceedToGameScreen = false,
  });

  LobbyPageState copyWith({
    PlayerInfo? playerInfo,
    List<PlayerInfo>? playerList,
    bool? isStartGameButtonVisible,
    ServerInfo? serverInfo,
    bool? shouldProceedToGameScreen,
  }) {
    return LobbyPageState(
      playerInfo: playerInfo ?? this.playerInfo,
      playerList: playerList ?? this.playerList,
      isStartGameButtonVisible: isStartGameButtonVisible ?? this.isStartGameButtonVisible,
      serverInfo: serverInfo ?? this.serverInfo,
      shouldProceedToGameScreen: shouldProceedToGameScreen ?? this.shouldProceedToGameScreen,
    );
  }
}
