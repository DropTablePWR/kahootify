import 'dart:async';
import 'dart:isolate';

import 'package:kahootify_server/server.dart';

// Test Server
Future<void> main() async {
  // Isolate

  // Listener function
  Function listener = (dynamic data) {
    print(data);
  };

  var results = await spawnIsolateServer(5, listener);
  SendPort sendPort = results.item2;

  while (true) {
    await Future.delayed(Duration(seconds: 5)).then((value) => sendPort.send("Main"));
  }

  // Classic
  // var server = Server(5);
  // await Future.delayed(Duration(seconds: 30)).then((value) => server.sendDataToAll("test"));
}
