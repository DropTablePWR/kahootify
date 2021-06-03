import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/const.dart';
import 'package:kahootify/core/data/server_discovery_repository.dart';
import 'package:kahootify/features/lobby/views/lobby_page.dart';
import 'package:kahootify_server/models/data.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:web_socket_channel/io.dart';

class ServerConnectionBloc extends Bloc<ServerConnectionEvent, ServerConnectState> {
  ServerConnectionBloc({required this.playerInfo}) : super(ConnectionInitialSate());
  final PlayerInfo playerInfo;
  var serverInput = StreamController();

  @override
  Stream<ServerConnectState> mapEventToState(ServerConnectionEvent event) async* {
    if (event is ConnectToServerFromCode) {
      yield ConnectingToServer();
      final serverInfo = await ServerDiscoveryRepository.getServerInfo(event.ip);
      if (serverInfo == null) {
        yield ErrorConnectingToServer(reason: 'Error when getting server info data');
      } else {
        yield connect(event.ip, serverInfo);
      }
    } else if (event is ConnectToServerBySelection) {
      yield ConnectingToServer();
      yield connect(event.serverInfo.ip, event.serverInfo);
    }
  }

  ServerConnectState connect(String ip, ServerInfo serverInfo) {
    try {
      var socket = IOWebSocketChannel.connect("ws://$ip:$kDefaultServerPort/");
      socket.sink.add(jsonEncode(playerInfo.toJson()));
      serverInput = StreamController();
      serverInput.stream.listen((event) {
        socket.sink.add(event);
      });
      return ConnectionSuccess(serverOutput: socket.stream.asBroadcastStream(), serverInput: serverInput, playerInfo: playerInfo, serverInfo: serverInfo);
    } catch (e) {
      return ErrorConnectingToServer(reason: 'Error when trying to connect to websocket');
    }
  }

  static void showConnectionDialog(BuildContext context) {
    var size = MediaQuery.of(context).size.shortestSide * 0.7;
    showDialog(
      context: context,
      builder: (_) {
        return Container(
          width: size,
          height: size,
          child: Material(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _dialogBody(context, context.watch<ServerConnectionBloc>().state),
              ),
            ),
          ),
        );
      },
    );
  }

  static List<Widget> _dialogBody(BuildContext context, ServerConnectState state) {
    if (state is ConnectingToServer) {
      return [Text('Connecting to server...'), Center(child: CircularProgressIndicator())];
    } else if (state is ErrorConnectingToServer) {
      return [
        Text('Error!', style: TextStyle(color: Colors.red)),
        Text((context.read<ServerConnectionBloc>().state as ErrorConnectingToServer).reason, style: TextStyle(color: Colors.red))
      ];
    } else {
      return [Text('Connected')];
    }
  }

  static void navigateToLobby(BuildContext context, ConnectionSuccess connectionData) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/lobby',
      (route) {
        return route.settings.name == '/discovery';
      },
      arguments: GameArgs(
        amIHost: false,
        serverInput: connectionData.serverInput,
        serverOutput: connectionData.serverOutput,
        initialServerInfo: connectionData.serverInfo,
        playerInfo: connectionData.playerInfo,
      ),
    ).then((_) {
      connectionData.serverInput.add(Data(DataType.goodbye));
      connectionData.serverInput.close();
    });
  }

  @override
  Future<void> close() {
    serverInput.close();
    return super.close();
  }
}

abstract class ServerConnectionEvent {}

class ConnectToServerFromCode extends ServerConnectionEvent {
  final String ip;

  ConnectToServerFromCode({required this.ip});
}

class ConnectToServerBySelection extends ServerConnectionEvent {
  final ServerInfo serverInfo;

  ConnectToServerBySelection({required this.serverInfo});
}

abstract class ServerConnectState {}

class ConnectionInitialSate extends ServerConnectState {}

class ConnectingToServer extends ServerConnectState {}

class ErrorConnectingToServer extends ServerConnectState {
  final String reason;

  ErrorConnectingToServer({required this.reason});
}

class ConnectionSuccess extends ServerConnectState {
  final Stream serverOutput;
  final StreamController serverInput;
  final PlayerInfo playerInfo;
  final ServerInfo serverInfo;

  ConnectionSuccess({required this.serverOutput, required this.serverInput, required this.playerInfo, required this.serverInfo});
}
