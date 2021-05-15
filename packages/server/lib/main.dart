import 'dart:async';
import 'dart:isolate';

import 'package:kahootify_server/models/category.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:kahootify_server/server.dart';

// Test Server
Future<void> main() async {
  // Isolate
  final serverOutput = StreamController();
  // Listener function
  serverOutput.stream.listen((data) {
    print("From Server: " + data.toString());
  });
  // first config
  ServerInfo serverInfo = ServerInfo.init(
    name: "test",
    maxNumberOfPlayers: 5,
    category: Category(id: 1, name: 'test'),
    answerTimeLimit: 20,
    numberOfQuestions: 10,
    ip: '192.168.1.23',
  );
  PlayerInfo playerInfo = PlayerInfo(id: 0, name: "localhost_Master");

  var results = await spawnIsolateServer(serverInfo, serverOutput, playerInfo);
  SendPort sendPort = results.item2;

  while (true) {
    await Future.delayed(Duration(seconds: 600)).then((value) => sendPort.send("Main"));
  }

  // Classic
  // var server = Server(5);
  // await Future.delayed(Duration(seconds: 30)).then((value) => server.sendDataToAll("test"));
}
