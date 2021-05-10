import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
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
    {'nick': 'Player4', 'isReady': false}
  ];

  QrImage qrImage = QrImage(
    data: "1234567890",
    version: QrVersions.auto,
    size: 200.0,
  );

  bool iAmReady = false;

  final maxNumberOfPlayers = 10;
  final numberOfPlayers = 7;
  String category = 'History';
  String serverName = 'Serer testowy';
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
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: qrImage,
                      );
                    },
                  );
                },
                child: Icon(Icons.qr_code),
              )),
        ],
      ),
      backLayer: _BackLayer(
          maxNumberOfPlayers: maxNumberOfPlayers,
          numberOfPlayers: numberOfPlayers,
          category: category,
          serverName: serverName,
          numberOfQuestions: numberOfQuestions,
          answerTimeLimit: answerTimeLimit),
      frontLayer: Scaffold(
        backgroundColor: kBackgroundLightColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: FlutterSwitch(
            valueFontSize: 10.0,
            width: 110,
            borderRadius: 30.0,
            value: iAmReady,
            activeText: "I am ready",
            inactiveText: "I am not ready",
            activeColor: kBackgroundGreenColor,
            showOnOff: true,
            onToggle: (value) {
              setState(() {
                iAmReady = value;
                print("I'M READY!!!");
                //TODO Zmiana stanu na ready
              });
            },
          ),
        ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.videogame_asset, size: 60),
                Flexible(
                  child: Text(
                    serverName,
                    style: TextStyle(fontSize: 35, color: kBasedBlackColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.category, size: 60),
                Flexible(
                  child: Text(
                    category,
                    style: TextStyle(fontSize: 35, color: kBasedBlackColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.format_list_numbered_outlined, size: 60),
                Flexible(
                  child: Text(
                    numberOfQuestions.toString(),
                    style: TextStyle(fontSize: 35, color: kBasedBlackColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.timelapse, size: 60),
                Flexible(
                  child: Text(
                    answerTimeLimit.toString() + ' s',
                    style: TextStyle(fontSize: 35, color: kBasedBlackColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.people, size: 60),
                Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(kBasedBlackColor),
                          strokeWidth: 10,
                          value: numberOfPlayers / maxNumberOfPlayers,
                        ),
                      ),
                    ),
                    Center(child: Text("$numberOfPlayers/$maxNumberOfPlayers", style: TextStyle(color: kBasedBlackColor, fontSize: 20))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
