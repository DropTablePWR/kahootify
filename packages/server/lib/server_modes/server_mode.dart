import 'dart:convert';
import 'dart:io';

import 'package:kahootify_server/models/data.dart';
import 'package:kahootify_server/models/error_info.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:kahootify_server/players/abstract_player.dart';
import 'package:kahootify_server/players/web_player.dart';

import '../server.dart';

abstract class ServerMode {
  Server server;

  ServerMode(this.server);

  ServerMode nextMode();

  void handleConnectionProtocol(PlayerInfo playerInfo, WebSocket socket) {
    var entry = findByPlayerCode(playerInfo.id);
    if (entry != null) {
      server.knownPlayers[socket] = entry.value;
      server.knownPlayers.remove(entry.key);
      entry.value.reconnect(socket, playerInfo);
      entry.value.send(server.serverInfo.toJson());
    } else {
      if (server.knownPlayers.length < server.serverInfo.maxNumberOfPlayers) {
        var player = WebPlayer(playerInfo, socket);
        server.knownPlayers[socket] = player;
        player.send(server.serverInfo.toJson());
      } else {
        print("Number of players exceeded");
        socket.add(jsonEncode(ErrorInfo("Number of players exceeded").toJson()));
        socket.close(WebSocketStatus.normalClosure, "Number of players exceeded");
      }
    }
  }

  void dataListener(dynamic event, AbstractPlayer player) {
    try {
      var json = jsonDecode(event);
      var data = Data.fromJson(json);
      handleData(data, json, player);
    } catch (e) {
      player.send(ErrorInfo("Invalid data2").toJson());
    }
  }

  MapEntry<dynamic, AbstractPlayer>? findByPlayerCode(int playerCode) {
    for (var entry in server.knownPlayers.entries)
      if (playerCode == entry.value.playerInfo.id) {
        return entry;
      }
    return null;
  }

  void handleData(Data data, Map<String, dynamic> json, AbstractPlayer player) {
    switch (data.dataType) {
      case DataType.serverInfo:
        handleServerInfo(ServerInfo.fromJson(json), player);
        break;
      case DataType.playerInfo:
        handlePlayerInfo(PlayerInfo.fromJson(json), player);
        break;
      case DataType.unknown:
        // TODO: Handle this case.
        break;
      case DataType.error:
        // TODO: Handle this case.
        break;
    }
  }

  void handleServerInfo(ServerInfo serverInfo, AbstractPlayer player);

  void handlePlayerInfo(PlayerInfo playerInfo, AbstractPlayer player);
}
