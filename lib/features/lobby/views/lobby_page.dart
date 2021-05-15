import 'dart:async';
import 'dart:convert';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify/widgets/player_number_indicator.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LobbyPage extends StatefulWidget {
  final bool isHost;
  final StreamController input;
  final Stream output;
  final ServerInfo initialServerInfo;

  const LobbyPage({required this.isHost, required this.input, required this.output, required this.initialServerInfo});

  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  List<PlayerInfo> playersList = [];
  bool iAmReady = true;
  bool allReady = true;

  @override
  void initState() {
    widget.output.listen((event) {
      print(event);
      var data = jsonDecode(event);
      if (data['dataType'] == "playerListInfo") {
        final updatedPlayers = List<PlayerInfo>.from(data['players'].map((rawPlayer) {
          return PlayerInfo.fromJson(rawPlayer);
        }).toList());
        setState(() {
          playersList = updatedPlayers;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      backLayerBackgroundColor: kBackgroundGreenColor,
      backgroundColor: kBackgroundLightColor,
      appBar: BackdropAppBar(
        title: Text("LOBBY"),
        backgroundColor: kBackgroundGreenColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 300,
                            width: 300,
                            child: QrImage(
                              data: widget.initialServerInfo.qrCode,
                              version: QrVersions.auto,
                              size: 300.0,
                            ),
                          ),
                          Text(widget.initialServerInfo.code)
                        ],
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.qr_code),
            ),
          ),
        ],
      ),
      backLayer: _BackLayer(serverInfo: widget.initialServerInfo),
      frontLayer: Scaffold(
        backgroundColor: kBackgroundLightColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: !widget.isHost
            ? FloatingActionButton.extended(
                backgroundColor: iAmReady ? kBackgroundGreenColor : kBasedBlackColor,
                label: Text(iAmReady ? "I am ready" : "I am not ready"),
                onPressed: () {
                  setState(() {
                    iAmReady = !iAmReady;
                    print(iAmReady.toString());
                    //TODO Zmiana stanu na ready
                  });
                },
                icon: Icon(iAmReady ? Icons.check : Icons.clear, color: Colors.white, size: 50),
          shape: OutlineInputBorder(),
        )
            : allReady
            ? FloatingActionButton.extended(
          backgroundColor: kBackgroundGreenColor,
          label: Text("Start a game"),
          onPressed: () {
            setState(() {
              iAmReady = !iAmReady;
              print("Start a game");
              //TODO Rozpoczęcie rozgrywki
            });
          },
          icon: Icon(Icons.outlined_flag, color: Colors.white, size: 50),
          shape: OutlineInputBorder(),
        )
            : SizedBox.shrink(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: ListView.builder(
            itemCount: playersList.length,
            padding: EdgeInsets.only(top: 35),
            itemBuilder: (BuildContext context, int index) => _PlayersListItem(playerInfo: playersList[index]),
          ),
        ),
      ),
    );
  }
}

class _PlayersListItem extends StatelessWidget {
  final PlayerInfo playerInfo;

  const _PlayersListItem({required this.playerInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: playerInfo.ready ? kBackgroundGreenColor : kBasedBlackColor,
      elevation: 10,
      child: SizedBox(
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(child: Text(playerInfo.name, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
            Container(child: Icon(playerInfo.ready ? Icons.check : Icons.clear, color: Colors.white, size: 50)),
          ],
        ),
      ),
    );
  }
}

class _BackLayer extends StatelessWidget {
  final ServerInfo serverInfo;

  const _BackLayer({required this.serverInfo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(children: [
          SizedBox(height: 30),
          _ServerInfoWidget(iconData: Icons.videogame_asset, text: serverInfo.name),
          SizedBox(height: 30),
          _ServerInfoWidget(iconData: Icons.category, text: serverInfo.category.name),
          SizedBox(height: 30),
          _ServerInfoWidget(iconData: Icons.format_list_numbered_outlined, text: serverInfo.numberOfQuestions.toString()),
          SizedBox(height: 30),
          _ServerInfoWidget(iconData: Icons.timelapse, text: serverInfo.answerTimeLimit.toString() + ' s'),
          SizedBox(height: 30),
          _ServerInfoWidget(iconData: Icons.people, customChild: PlayerNumberIndicator(serverInfo: serverInfo))
        ]),
      ),
    );
  }
}

class _ServerInfoWidget extends StatelessWidget {
  final IconData iconData;
  final Widget? customChild;
  final String? text;

  const _ServerInfoWidget({Key? key, required this.iconData, this.customChild, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(iconData, size: 60),
        SizedBox(width: 30),
        customChild ??
            Flexible(
              child: Text(
                text ?? "",
                style: TextStyle(fontSize: 35, color: kBasedBlackColor, fontWeight: FontWeight.bold),
              ),
            ),
      ],
    );
  }
}
