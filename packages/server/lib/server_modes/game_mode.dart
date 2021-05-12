import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:kahootify_server/players/abstract_player.dart';
import 'package:kahootify_server/server.dart';
import 'package:kahootify_server/server_modes/server_mode.dart';

class GameMode extends ServerMode {
  GameMode(Server server) : super(server);

  @override
  ServerMode nextMode() {
    // TODO: implement nextMode
    throw UnimplementedError();
  }

  @override
  void handlePlayerInfo(PlayerInfo playerInfo, AbstractPlayer player) {
    // TODO: implement handlePlayerInfo
  }

  @override
  void handleServerInfo(ServerInfo serverInfo, AbstractPlayer player) {
    // TODO: implement handleServerInfo
  }
}
