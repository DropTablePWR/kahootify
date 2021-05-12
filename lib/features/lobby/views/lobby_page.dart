import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:kahootify/color_consts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LobbyPage extends StatefulWidget {
  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  List playersList = [
    {'nick': 'Player1', 'isReady': true},
    {'nick': 'Player2', 'isReady': false},
    {'nick': 'Player3', 'isReady': true},
  ];

  bool iAmReady = true;
  bool isPlayer = true;
  bool allReady = true;

  String qrData = "1234567890";
  final maxNumberOfPlayers = 10;
  final numberOfPlayers = 7;
  String category = 'History';
  String serverName = 'SERVER';
  final numberOfQuestions = 20;
  final answerTimeLimit = 13;

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
                      content: Container(
                        height: 300,
                        width: 300,
                        child: QrImage(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 300.0,
                        ),
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
      backLayer: _BackLayer(
        maxNumberOfPlayers: maxNumberOfPlayers,
        numberOfPlayers: numberOfPlayers,
        category: category,
        serverName: serverName,
        numberOfQuestions: numberOfQuestions,
        answerTimeLimit: answerTimeLimit,
      ),
      frontLayer: Scaffold(
        backgroundColor: kBackgroundLightColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: isPlayer
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
          child: ListView(
            children: [SizedBox(height: 35), for (var i in playersList) _PlayersListItem(playerNick: i['nick'], isReady: i['isReady'])],
          ),
        ),
      ),
    );
  }
}

class _PlayersListItem extends StatelessWidget {
  final String playerNick;
  final bool isReady;

  const _PlayersListItem({Key? key, required this.playerNick, required this.isReady}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: isReady ? kBackgroundGreenColor : kBasedBlackColor,
      elevation: 10,
      child: SizedBox(
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(child: Text(playerNick, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
            Container(child: Icon(isReady ? Icons.check : Icons.clear, color: Colors.white, size: 50)),
          ],
        ),
      ),
    );
  }
}

class _BackLayer extends StatelessWidget {
  final maxNumberOfPlayers;
  final numberOfPlayers;
  final String category;
  final String serverName;
  final numberOfQuestions;
  final answerTimeLimit;

  const _BackLayer(
      {Key? key,
      required this.maxNumberOfPlayers,
      required this.numberOfPlayers,
      required this.category,
      required this.serverName,
      required this.numberOfQuestions,
      required this.answerTimeLimit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(children: [
          SizedBox(height: 30),
          _ServerInfoWidget(iconData: Icons.videogame_asset, text: serverName),
          SizedBox(height: 30),
          _ServerInfoWidget(iconData: Icons.category, text: category),
          SizedBox(height: 30),
          _ServerInfoWidget(iconData: Icons.format_list_numbered_outlined, text: numberOfQuestions.toString()),
          SizedBox(height: 30),
          _ServerInfoWidget(iconData: Icons.timelapse, text: answerTimeLimit.toString() + ' s'),
          SizedBox(height: 30),
          _ServerInfoWidget(
            iconData: Icons.people,
            customChild: Container(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kBasedBlackColor),
                strokeWidth: 10,
                value: numberOfPlayers / maxNumberOfPlayers,
              ),
            ),
          )
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
