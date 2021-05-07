import 'dart:async';
import 'dart:isolate';

import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:kahootify_server/server.dart';

// Test Server
Future<void> main() async {
  // Isolate

  // Listener function
  Function listener = (dynamic data) {
    print("From Server: " + data.toString());
  };
  // first config
  ServerInfo serverInfo = ServerInfo.init(name: "test", maxNumberOfPlayers: 5);
  PlayerInfo playerInfo = PlayerInfo(0, "localhost_Master");

  var results = await spawnIsolateServer(serverInfo, listener, playerInfo);
  SendPort sendPort = results.item2;

  while (true) {
    await Future.delayed(Duration(seconds: 600)).then((value) => sendPort.send("Main"));
  }

  // Classic
  // var server = Server(5);
  // await Future.delayed(Duration(seconds: 30)).then((value) => server.sendDataToAll("test"));
}
