import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:kahootify_server/player.dart';
import 'package:tuple/tuple.dart';

import 'const.dart';

class Server {
  final int maxPlayers;
  late final server;
  Map<int, Player> knownPlayers = {};

  Server(this.maxPlayers) {
    initialize();
  }

  void initialize() async {
    server = await HttpServer.bind(kServerUrl, kServerPort, shared: true);
    await for (HttpRequest req in server) {
      if (req.uri.path == '/') {
        var socket = await WebSocketTransformer.upgrade(req);
        socket.listen((event) {
          var data = jsonDecode(event);
          var id = data['id'];
          if (id != null) {
            handleConnectionProtocol(id, socket);
          } else {
            handleData(data, socket);
          }
        });
      }
    }
  }

  static void sayHello(SendPort sendPort) {
    sendPort.send("Hello from Isolate");
  }

  void handleConnectionProtocol(int id, WebSocket socket) {
    if (wasPlayerConnected(id)) {
      Player foundPlayer = knownPlayers[id]!;
      foundPlayer.socket.close(WebSocketStatus.goingAway, "Reconnected player");
      foundPlayer.socket = socket;
    } else {
      if (knownPlayers.length < maxPlayers) {
        knownPlayers[id] = Player(id, socket);
      } else {
        socket.close(WebSocketStatus.normalClosure, "Number of players exceeded");
      }
    }
  }

  bool wasPlayerConnected(int id) {
    return knownPlayers.containsKey(id);
  }

  void handleData(dynamic data, WebSocket socket) {
    //  TODO handle data
  }

  void sendDataToAll(dynamic data) {
    knownPlayers.forEach((key, player) {
      try {
        player.socket.add(data);
      } catch (e) {}
    });
  }
}

void _createRunningServer(Tuple2<SendPort, int> arguments) {
  var maxPlayers = arguments.item2;
  Server(maxPlayers);
}

Future<Tuple2<Isolate, ReceivePort>> spawnIsolateServer(int maxPlayers) async {
  ReceivePort receivePort = ReceivePort();
  Isolate isolate = await Isolate.spawn(_createRunningServer, Tuple2(receivePort.sendPort, maxPlayers));
  return Tuple2(isolate, receivePort);
}
