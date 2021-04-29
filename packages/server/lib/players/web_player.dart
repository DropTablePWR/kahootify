import 'dart:io';

import 'abstract_player.dart';

class WebPlayer extends AbstractPlayer {
  WebSocket socket;

  WebPlayer(int playerCode, this.socket) : super(playerCode);

  @override
  void send(data) {
    socket.add(data);
  }

  @override
  void reconnect(socket) {
    this.socket.close(WebSocketStatus.goingAway, "Reconnected player");
    this.socket = socket;
    print("reconnecting player: " + this.playerCode.toString());
  }
}
