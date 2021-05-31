import 'dart:convert';
import 'dart:io';

import 'package:kahootify_server/models/player_info.dart';

import 'abstract_player.dart';

class WebPlayer extends AbstractPlayer {
  WebSocket socket;

  WebPlayer(PlayerInfo playerInfo, this.socket) : super(playerInfo);

  @override
  void send(data) {
    socket.add(jsonEncode(data));
  }

  @override
  void reconnect(socket, PlayerInfo playerInfo) {
    this.socket.close(WebSocketStatus.goingAway, "Reconnected player");
    this.socket = socket;

    print("reconnecting player: " + this.playerInfo.id.toString());
  }
}
