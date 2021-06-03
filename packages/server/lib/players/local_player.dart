import 'dart:convert';
import 'dart:isolate';

import 'package:kahootify_server/models/player_info.dart';

import '../const.dart';
import 'abstract_player.dart';

class LocalPlayer extends AbstractPlayer {
  SendPort sendPort;

  LocalPlayer(PlayerInfo playerInfo, this.sendPort) : super(playerInfo);

  @override
  send(data) {
    Future.delayed(kLocalPlayerDelay).then((_) => sendPort.send(jsonEncode(data)));
  }

  @override
  void reconnect(data, PlayerInfo playerInfo) {
    throw Exception("Local player can't be reconnected!!!");
  }
}
