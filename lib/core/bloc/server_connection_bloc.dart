import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';

class ServerConnectionBloc extends Bloc<ServerConnectionEvent, ServerConnectState> {
  ServerConnectionBloc() : super(ConnectionInitialSate());

  @override
  Stream<ServerConnectState> mapEventToState(ServerConnectionEvent event) async* {
    if (event is ConnectToServerBySelection) {}
  }
}

abstract class ServerConnectionEvent {}

class ConnectToServerByCode extends ServerConnectionEvent {
  final String code;

  ConnectToServerByCode({required this.code});
}

class ConnectToServerBySelection extends ServerConnectionEvent {
  final ServerInfo serverInfo;

  ConnectToServerBySelection({required this.serverInfo});
}

abstract class ServerConnectState {}

class ConnectionInitialSate extends ServerConnectState {}

class ConnectionSuccess extends ServerConnectState {
  final Stream serverOutput;
  final StreamController serverInput;
  final PlayerInfo playerInfo;
  final ServerInfo serverInfo;

  ConnectionSuccess({required this.serverOutput, required this.serverInput, required this.playerInfo, required this.serverInfo});
}
