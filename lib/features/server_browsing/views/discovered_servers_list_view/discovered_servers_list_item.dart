import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify/const.dart';
import 'package:kahootify/core/bloc/settings_cubit.dart';
import 'package:kahootify/features/lobby/views/lobby_page.dart';
import 'package:kahootify/widgets/player_number_indicator.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:web_socket_channel/io.dart';

class DiscoveredServerListItem extends StatelessWidget {
  final ServerInfo serverInfo;

  const DiscoveredServerListItem({required this.serverInfo});

  static const _itemTextStyle = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500);

  void connect(BuildContext context) async {
    var socket = IOWebSocketChannel.connect("ws://${serverInfo.ip}:$kDefaultServerPort/");
    final settings = context.read<SettingsCubit>().state;
    final playerInfo = PlayerInfo(id: settings.playerId, name: settings.playerName);
    socket.sink.add(jsonEncode(playerInfo.toJson()));
    final input = StreamController();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => LobbyPage(isHost: false, input: input, output: socket.stream, initialServerInfo: serverInfo)));
  }

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
      color: kBackgroundGreenColor,
      elevation: 5,
      child: SizedBox(
        height: 70.0,
        child: InkWell(
          onLongPress: () => Fluttertoast.showToast(msg: "Server ip: " + serverInfo.ip),
          onTap: () => connect(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(serverInfo.name, style: _itemTextStyle)),
                Expanded(child: PlayerNumberIndicator(serverInfo: serverInfo)),
                Expanded(child: Text(getServerStatus(serverInfo.serverStatus), textAlign: TextAlign.right, style: _itemTextStyle)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
