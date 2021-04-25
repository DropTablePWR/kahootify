import 'dart:io';

class Player {
  final int playerCode;
  WebSocket socket;

  Player(this.playerCode, this.socket) {
    print("I'm working: " + playerCode.toString());
  }
}
