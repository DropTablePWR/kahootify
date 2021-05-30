import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/core/bloc/server_connection_bloc.dart';
import 'package:kahootify/widgets/player_number_indicator.dart';
import 'package:kahootify_server/models/server_info.dart';

class DiscoveredServerListItem extends StatelessWidget {
  final ServerInfo serverInfo;

  const DiscoveredServerListItem({required this.serverInfo});

  static const _itemTextStyle = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500);

  String getServerStatus(ServerStatus serverStatus) {
    switch (serverStatus) {
      case ServerStatus.lobby:
        return 'In Lobby';
      case ServerStatus.inGame:
        return 'In Game';
      case ServerStatus.results:
        return 'In Results Screen';
      default:
        return '----';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: KColors.backgroundGreenColor,
      elevation: 5,
      child: SizedBox(
        height: 70.0,
        child: InkWell(
          onLongPress: () => Fluttertoast.showToast(msg: "Server ip: " + serverInfo.ip),
          onTap: () => context.read<ServerConnectionBloc>().add(ConnectToServerBySelection(serverInfo: serverInfo)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(serverInfo.name, style: DiscoveredServerListItem._itemTextStyle)),
                Expanded(child: PlayerNumberIndicator(serverInfo: serverInfo)),
                Expanded(child: Text(getServerStatus(serverInfo.serverStatus), textAlign: TextAlign.right, style: DiscoveredServerListItem._itemTextStyle)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
