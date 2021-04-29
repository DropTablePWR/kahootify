import 'dart:isolate';

import 'abstract_player.dart';

class LocalPlayer extends AbstractPlayer {
  SendPort sendPort;

  LocalPlayer(int playerCode, this.sendPort) : super(playerCode);

  @override
  send(data) {
    sendPort.send(data);
  }

  @override
  void reconnect(data) {
    throw Exception("Local player can't be reconnected!!!");
  }
}
