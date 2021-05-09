import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:kahootify_server/models/error_info.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/player_list_info.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:kahootify_server/players/abstract_player.dart';
import 'package:kahootify_server/players/local_player.dart';
import 'package:kahootify_server/server_modes/lobby_mode.dart';
import 'package:kahootify_server/server_modes/server_mode.dart';
import 'package:tuple/tuple.dart';

import 'const.dart';
import 'models/data.dart';

class Server {
  ServerInfo _serverInfo;
  late final server;
  Map<dynamic, AbstractPlayer> knownPlayers = {};
  late ServerMode serverMode;

  Server(this._serverInfo) {
    serverMode = LobbyMode(this);
    initialize();
  }

  Server.isolate(this._serverInfo, SendPort sendPort, PlayerInfo? playerInfo) {
    serverMode = LobbyMode(this);
    ReceivePort receivePort = ReceivePort();
    // Sending port to main
    sendPort.send(receivePort.sendPort);

    if (playerInfo != null) {
      var player = LocalPlayer(playerInfo, sendPort);
      knownPlayers[sendPort] = player;
      player.send(serverInfo.toJson());
      receivePort.listen((event) {
        serverMode.dataListener(event, player);
      });
    }
    initialize();
  }

  void initialize() async {
    server = await HttpServer.bind(kServerUrl, kServerPort, shared: true);
    print("Server initialized");
    await for (HttpRequest req in server) {
      if (req.uri.path == '/') {
        try {
          var socket = await WebSocketTransformer.upgrade(req);
          socket.listen((event) {
            var json = jsonDecode(event);
            var data = Data.fromJson(json);

            if (knownPlayers[socket] != null) {
              serverMode.dataListener(event, knownPlayers[socket]!);
            } else {
              try {
                if (data.dataType == DataType.playerInfo) {
                  serverMode.handleConnectionProtocol(PlayerInfo.fromJson(json), socket);
                } else {
                  socket.add(ErrorInfo("First send playerInfo").toJson());
                }
              } catch (e) {
                print(e);
                socket.add(ErrorInfo("Invalid data").toJson());
              }
            }
          });
        } catch (e) {
          print(e);
          print("Invalid upgrade");
        }
      } else if (req.uri.path == '/info') {
        req.response.write(serverInfo.toJson());
        await req.response.close();
      }
    }
  }

  ServerInfo get serverInfo {
    _serverInfo.currentNumberOfPlayers = knownPlayers.length;
    return _serverInfo;
  }

  set serverInfo(ServerInfo value) {
    _serverInfo = value;
  }

  void sendAllPlayerListInfo() {
    var players = knownPlayers.values.map((e) => e.playerInfo).toList();
    var data = PlayerListInfo(players);
    sendDataToAll(data.toJson());
  }

  void sendDataToAll(dynamic data) {
    knownPlayers.forEach((key, player) {
      try {
        player.send(data);
      } catch (e) {}
    });
  }
}

void _createRunningServer(Tuple3<SendPort, ServerInfo, PlayerInfo?> arguments) {
  var serverInfo = arguments.item2;
  var sendPort = arguments.item1;
  var playerInfo = arguments.item3;
  Server.isolate(serverInfo, sendPort, playerInfo);
}

// if playerInfo is not null, then create localhost player
Future<Tuple2<Isolate, SendPort>> spawnIsolateServer(ServerInfo serverInfo, Function listener, PlayerInfo? playerInfo) async {
  Completer completer = new Completer<SendPort>();
  ReceivePort receivePort = ReceivePort();

  receivePort.listen((data) {
    if (data is SendPort) {
      completer.complete(data);
    } else {
      listener(data);
    }
  });

  Isolate isolate = await Isolate.spawn(_createRunningServer, Tuple3(receivePort.sendPort, serverInfo, playerInfo));
  var sendPort = await completer.future as SendPort;
  return Tuple2(isolate, sendPort);
}
