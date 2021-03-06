import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:kahootify_server/models/error_info.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/player_list_info.dart';
import 'package:kahootify_server/models/ranking_info.dart';
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
      sendDataToAll(generatePlayerListInfo().toJson());
      receivePort.listen((event) {
        serverMode.dataListener(event, player);
      });
    }
    initialize();
  }

  void sendDataToHost(dynamic data) {
    for (AbstractPlayer player in knownPlayers.values) {
      if (player is LocalPlayer) {
        player.send(data);
        return;
      }
    }
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
                  socket.add(jsonEncode(ErrorInfo("First send playerInfo").toJson()));
                }
              } catch (e) {
                print(e);
                socket.add(jsonEncode(ErrorInfo("Invalid data").toJson()));
              }
            }
          });
        } catch (e) {
          print(e);
          print("Invalid upgrade");
        }
      } else if (req.uri.path == '/info') {
        req.response.write(jsonEncode(serverInfo.toJson()));
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

  bool _everyoneIsReady() {
    for (AbstractPlayer player in knownPlayers.values) {
      if (player.playerInfo.ready == false) {
        return false;
      }
    }
    return true;
  }

  PlayerListInfo generatePlayerListInfo() {
    var players = knownPlayers.values.map((e) => e.playerInfo).toList();
    return PlayerListInfo(players, _everyoneIsReady());
  }

  RankingInfo generateRankingInfo() {
    var players = knownPlayers.values.map((e) => e.playerInfo).toList();
    players.sort((a, b) => b.score.compareTo(a.score));
    return RankingInfo(players);
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
Future<Tuple2<Isolate, SendPort>> spawnIsolateServer(ServerInfo serverInfo, StreamController output, PlayerInfo? playerInfo) async {
  Completer completer = new Completer<SendPort>();
  ReceivePort receivePort = ReceivePort();

  receivePort.listen((data) {
    if (data is SendPort) {
      completer.complete(data);
    } else {
      output.add(data);
    }
  });

  Isolate isolate = await Isolate.spawn(_createRunningServer, Tuple3(receivePort.sendPort, serverInfo, playerInfo));
  var sendPort = await completer.future as SendPort;
  return Tuple2(isolate, sendPort);
}
