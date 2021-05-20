import 'dart:async';
import 'dart:convert';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify/features/lobby/views/players_list_view.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';

import 'widgets.dart';

class LobbyPage extends StatefulWidget {
  final bool isHost;
  final StreamController input;
  final Stream output;
  final ServerInfo initialServerInfo;
  final PlayerInfo playerInfo;

  const LobbyPage({required this.isHost, required this.input, required this.output, required this.initialServerInfo, required this.playerInfo});

  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  List<PlayerInfo> playersList = [];
  late bool iAmReady;
  bool allReady = false;
  late PlayerInfo playerInfo;

  @override
  void initState() {
    playerInfo = widget.playerInfo;
    iAmReady = playerInfo.ready;
    widget.output.listen((event) {
      print(event);
      var data = jsonDecode(event);
      switch (data['dataType']) {
        case 'playerListInfo':
          final updatedPlayers = List<PlayerInfo>.from(data['players'].map((rawPlayer) => PlayerInfo.fromJson(rawPlayer)).toList());
          setState(() => playersList = updatedPlayers);
          break;
        case 'playerInfo':
          print("coś");
          break;
      }
    });
    super.initState();
  }

  Widget getFAB() {
    if (widget.isHost) {
      if (allReady) {
        return StartGameButton();
      }
      return SizedBox.shrink();
    } else {
      return IAmReadyButton(
        iAmReady: iAmReady,
        onPressed: () {
          setState(() {
            iAmReady = !iAmReady;
            print(iAmReady.toString());
            widget.input.add(jsonEncode(playerInfo.copyWith(ready: iAmReady).toJson()));
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        return BackdropScaffold(
          headerHeight: MediaQuery.of(context).size.height * 0.5,
          stickyFrontLayer: true,
          backLayerBackgroundColor: kBackgroundGreenColor,
          backgroundColor: kBackgroundLightColor,
          appBar: BackdropAppBar(
            title: Text("LOBBY"),
            backgroundColor: kBackgroundGreenColor,
            actions: [
              DisplayQRCodeButton(qrCode: widget.initialServerInfo.qrCode, code: widget.initialServerInfo.code),
            ],
          ),
          backLayer: BackLayer(serverInfo: widget.initialServerInfo, isPortrait: true),
          frontLayer: Scaffold(
            backgroundColor: kBackgroundLightColor,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: getFAB(),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: PlayersListView(playersList: playersList, maxNumberOfPlayers: widget.initialServerInfo.maxNumberOfPlayers, isHorizontal: false),
            ),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: kBackgroundLightColor,
          appBar: AppBar(
            title: Text("LOBBY"),
            backgroundColor: kBackgroundGreenColor,
            actions: [
              DisplayQRCodeButton(qrCode: widget.initialServerInfo.qrCode, code: widget.initialServerInfo.code),
            ],
          ),
          floatingActionButton: getFAB(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PlayersListView(playersList: playersList, maxNumberOfPlayers: widget.initialServerInfo.maxNumberOfPlayers, isHorizontal: true),
                ),
                Expanded(
                    child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 100),
                        child: SizedBox(width: 200, child: BackLayer(serverInfo: widget.initialServerInfo, isPortrait: false))))
              ],
            ),
          ),
        );
      }
    });
  }
}
