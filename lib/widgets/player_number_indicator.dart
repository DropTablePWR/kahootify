import 'package:flutter/material.dart';
import 'package:kahootify_server/models/server_info.dart';

class PlayerNumberIndicator extends StatelessWidget {
  const PlayerNumberIndicator({required this.serverInfo});

  final ServerInfo serverInfo;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 5,
          value: serverInfo.currentNumberOfPlayers / serverInfo.maxNumberOfPlayers,
        ),
      ),
      Center(child: Text("${serverInfo.currentNumberOfPlayers}/${serverInfo.maxNumberOfPlayers}", style: TextStyle(color: Colors.white))),
    ]);
  }
}
