import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify/const.dart';
import 'package:kahootify/widgets/player_number_indicator.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:web_socket_channel/io.dart';

class DiscoveredServerListItem extends StatelessWidget {
  final ServerInfo serverInfo;

  const DiscoveredServerListItem({required this.serverInfo});

  static const _itemTextStyle = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500);

  void connect() async {
    var socket = IOWebSocketChannel.connect("ws://${serverInfo.ip}:$kDefaultServerPort/");
    socket.sink.add(jsonEncode({'id': 1}));
    socket.stream.listen((event) {
      print(event);
    });

    while (true) {
      await Future.delayed(Duration(seconds: 3)).then((value) => socket.sink.add(jsonEncode({'message': "player"})));
    }
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
          onTap: connect,
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
