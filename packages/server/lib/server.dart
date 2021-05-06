import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:kahootify_server/models/Error.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:kahootify_server/players/abstract_player.dart';
import 'package:kahootify_server/players/local_player.dart';
import 'package:kahootify_server/players/web_player.dart';
import 'package:tuple/tuple.dart';

import 'const.dart';

class Server {
  ServerInfo serverInfo;
  late final server;
  Map<dynamic, AbstractPlayer> knownPlayers = {};

  Server(this.serverInfo) {
    initialize();
  }

  Server.isolate(this.serverInfo, SendPort sendPort, bool withPlayer) {
    ReceivePort receivePort = ReceivePort();
    // Sending port to main
    sendPort.send(receivePort.sendPort);

    if (withPlayer) {
      var player = LocalPlayer(0, sendPort);
      knownPlayers[sendPort] = player;
      receivePort.listen((data) {
        handleData(data, player);
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
            try {
              var data = jsonDecode(event);
              var id = data['id'];
              if (id != null) {
                handleConnectionProtocol(id, socket);
              } else {
                var player = knownPlayers[socket];
                if (player == null) {
                  print("Unauthorized connection");
                  socket.close(WebSocketStatus.normalClosure, "Unauthorized connection");
                } else {
                  handleData(data, player);
                }
              }
            } catch (e) {
              socket.add(Error("Invalid data").toJson());
            }
          });
        } catch (e) {
          req.response.write(Error("Something went wrong").toJson());
        }
      } else if (req.uri.path == '/info') {
        var z = serverInfo.toJson();
        req.response.write(z);
      }
    }
  }

  void handleConnectionProtocol(int id, WebSocket socket) {
    var entry = findByPlayerCode(id);
    if (entry != null) {
      knownPlayers[socket] = entry.value;
      knownPlayers.remove(entry.key);
      entry.value.reconnect(socket);
    } else {
      if (knownPlayers.length < serverInfo.maxNumberOfPlayers) {
        knownPlayers[socket] = WebPlayer(id, socket);
      } else {
        print("Number of players exceeded");
        socket.close(WebSocketStatus.normalClosure, "Number of players exceeded");
      }
    }
  }

  // return
  MapEntry<dynamic, AbstractPlayer>? findByPlayerCode(int playerCode) {
    for (var entry in knownPlayers.entries)
      if (playerCode == entry.value.playerCode) {
        return entry;
      }
    return null;
  }

  void handleData(dynamic data, AbstractPlayer player) {
    //  TODO handle data
    print(data.toString() + " : " + player.playerCode.toString());
  }

  void sendDataToAll(dynamic data) {
    knownPlayers.forEach((key, player) {
      try {
        player.send(data);
      } catch (e) {}
    });
  }
}

void _createRunningServer(Tuple3<SendPort, ServerInfo, bool> arguments) {
  var serverInfo = arguments.item2;
  var sendPort = arguments.item1;
  var withPlayer = arguments.item3;
  Server.isolate(serverInfo, sendPort, withPlayer);
}

Future<Tuple2<Isolate, SendPort>> spawnIsolateServer(ServerInfo serverInfo, Function listener, bool withPlayer) async {
  Completer completer = new Completer<SendPort>();
  ReceivePort receivePort = ReceivePort();

  receivePort.listen((data) {
    if (data is SendPort) {
      completer.complete(data);
    } else {
      listener(data);
    }
  });

  Isolate isolate = await Isolate.spawn(_createRunningServer, Tuple3(receivePort.sendPort, serverInfo, withPlayer));
  var sendPort = await completer.future as SendPort;
  return Tuple2(isolate, sendPort);
}
