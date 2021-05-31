import 'package:kahootify_server/models/player_info.dart';

abstract class AbstractPlayer {
  PlayerInfo playerInfo;

  AbstractPlayer(this.playerInfo) {
    print("I'm working: " + playerInfo.id.toString());
  }

  void send(dynamic data);

  void reconnect(dynamic data, PlayerInfo playerInfo);

  dynamic getConnection();
}
