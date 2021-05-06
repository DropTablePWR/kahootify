import 'dart:async';
import 'dart:isolate';

import 'package:kahootify_server/models/server_info.dart';
import 'package:kahootify_server/server.dart';

// Test Server
Future<void> main() async {
  // Isolate

  // Listener function
  Function listener = (dynamic data) {
    print(data);
  };
  // first config
  ServerInfo serverInfo = ServerInfo.init(name: "test", maxNumberOfPlayers: 5);

  var results = await spawnIsolateServer(serverInfo, listener, true);
  SendPort sendPort = results.item2;

  while (true) {
    await Future.delayed(Duration(seconds: 10)).then((value) => sendPort.send("Main"));
  }

  // Classic
  // var server = Server(5);
  // await Future.delayed(Duration(seconds: 30)).then((value) => server.sendDataToAll("test"));
}
