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
    {'nick': 'Player4', 'isReady': false}
  ];

  QrImage qrImage = QrImage(
    data: "1234567890",
    version: QrVersions.auto,
    size: 300.0,
  );

  bool iAmReady = true;
  bool isPlayer = true;
  bool allReady = true;

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
                : Text(''),
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
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.videogame_asset, size: 60),
                SizedBox(width: 30),
                Flexible(
                  child: Text(
                    serverName,
                    style: TextStyle(fontSize: 35, color: kBasedBlackColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.category, size: 60),
                SizedBox(width: 30),
                Flexible(
                  child: Text(
                    category,
                    style: TextStyle(fontSize: 35, color: kBasedBlackColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.format_list_numbered_outlined, size: 60),
                SizedBox(width: 30),
                Flexible(
                  child: Text(
                    numberOfQuestions.toString(),
                    style: TextStyle(fontSize: 35, color: kBasedBlackColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.timelapse, size: 60),
                SizedBox(width: 30),
                Flexible(
                  child: Text(
                    answerTimeLimit.toString() + ' s',
                    style: TextStyle(fontSize: 35, color: kBasedBlackColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.people, size: 60),
                SizedBox(width: 30),
                Container(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kBasedBlackColor),
                    strokeWidth: 10,
                    value: numberOfPlayers / maxNumberOfPlayers,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
