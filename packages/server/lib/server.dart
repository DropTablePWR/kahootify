import 'dart:async';
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
  SendPort? isolateToMain;

  Server(this.maxPlayers) {
    initialize();
  }

  Server.isolate(this.maxPlayers, this.isolateToMain) {
    ReceivePort mainToIsolateStream = ReceivePort();
    // Sending port to main
    isolateToMain!.send(mainToIsolateStream.sendPort);
    mainToIsolateStream.listen((data) {
      handleDataFromMain(data);
    });
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

  void handleDataFromMain(dynamic data) {
    //  TODO handle data to isolate
    print(data);
    isolateToMain!.send(data + "- isolate answer");
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
  var sendPort = arguments.item1;
  Server.isolate(maxPlayers, sendPort);
}

Future<Tuple2<Isolate, SendPort>> spawnIsolateServer(int maxPlayers, Function listener) async {
  Completer completer = new Completer<SendPort>();
  ReceivePort receivePort = ReceivePort();

  receivePort.listen((data) {
    if (data is SendPort) {
      completer.complete(data);
    } else {
      listener(data);
    }
  });

  Isolate isolate = await Isolate.spawn(_createRunningServer, Tuple2(receivePort.sendPort, maxPlayers));
  var sendPort = await completer.future as SendPort;
  return Tuple2(isolate, sendPort);
}
