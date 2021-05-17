import 'dart:async';
import 'dart:convert';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return orientation == Orientation.portrait
          ? BackdropScaffold(
              headerHeight: 400,
              stickyFrontLayer: true,
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
              backLayer: _BackLayer(serverInfo: widget.initialServerInfo, isPortrait: true),
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
                            widget.input.add(jsonEncode(playerInfo.copyWith(ready: iAmReady).toJson()));
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
                    itemCount: widget.initialServerInfo.maxNumberOfPlayers,
                    padding: EdgeInsets.only(top: 35),
                    itemBuilder: (BuildContext context, int index) {
                      if (index < playersList.length) {
                        return _PlayersListItem(playerInfo: playersList[index]);
                      }
                      return _PlayersListItem();
                    },
                  ),
                ),
              ),
            )
          : Scaffold(
              backgroundColor: kBackgroundLightColor,
              appBar: AppBar(
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
                                    height: 200,
                                    width: 200,
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
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: !widget.isHost
                  ? FloatingActionButton.extended(
                      backgroundColor: iAmReady ? kBackgroundGreenColor : kBasedBlackColor,
                      label: Text(iAmReady ? "I am ready" : "I am not ready"),
                      onPressed: () {
                        setState(() {
                          iAmReady = !iAmReady;
                          print(iAmReady.toString());
                          widget.input.add(jsonEncode(playerInfo.copyWith(ready: iAmReady).toJson()));
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
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.initialServerInfo.maxNumberOfPlayers,
                      padding: EdgeInsets.only(top: 35),
                      itemBuilder: (BuildContext context, int index) {
                        if (index < playersList.length) {
                          return _PlayersListItem(playerInfo: playersList[index]);
                        }
                        return _PlayersListItem();
                      },
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(child: SizedBox(width: 200, child: _BackLayer(serverInfo: widget.initialServerInfo, isPortrait: false))))
                ],
              ),
            );
    });
  }
}

class _PlayersListItem extends StatelessWidget {
  final PlayerInfo? playerInfo;

  const _PlayersListItem({this.playerInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: kBasedBlackColor,
          width: 1.5,
        ),
      ),
      color: playerInfo == null
          ? Colors.grey.shade300
          : playerInfo!.ready
              ? kBackgroundGreenColor
              : kBasedBlackColor,
      elevation: 10,
      child: SizedBox(
        height: 50.0,
        child: playerInfo == null
            ? Center(
                child: Text('EMPTY', style: TextStyle(color: kBasedBlackColor, fontSize: 18, fontWeight: FontWeight.bold)),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(child: Text(playerInfo!.name, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                  Container(child: Icon(playerInfo!.ready ? Icons.check : Icons.clear, color: Colors.white, size: 50)),
                ],
              ),
      ),
    );
  }
}

class _BackLayer extends StatelessWidget {
  final ServerInfo serverInfo;
  final bool isPortrait;

  const _BackLayer({required this.serverInfo, required this.isPortrait});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(children: [
          SizedBox(height: 30),
          _ServerInfoWidget(name: "SERVER NAME: ", text: serverInfo.name, isPortrait: isPortrait),
          SizedBox(height: 30),
          _ServerInfoWidget(name: "CATEGORY: ", text: serverInfo.category.name, isPortrait: isPortrait),
          SizedBox(height: 30),
          _ServerInfoWidget(name: "NUMBER OF QUESTIONS: ", text: serverInfo.numberOfQuestions.toString(), isPortrait: isPortrait),
          SizedBox(height: 30),
          _ServerInfoWidget(name: "TIME TO ANSWER: ", text: serverInfo.answerTimeLimit.toString() + ' s', isPortrait: isPortrait)
        ]),
      ),
    );
  }
}

class _ServerInfoWidget extends StatelessWidget {
  final String name;
  final String? text;
  final bool isPortrait;

  const _ServerInfoWidget({Key? key, required this.name, this.text, this.isPortrait = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(fontSize: 15, color: isPortrait ? Colors.white : kBasedBlackColor, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 25),
        Expanded(
          child: Text(
            text ?? "",
            style: TextStyle(fontSize: 15, color: isPortrait ? Colors.white : kBasedBlackColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
