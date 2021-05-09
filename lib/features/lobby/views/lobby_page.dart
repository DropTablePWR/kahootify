import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:kahootify/color_consts.dart';

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
      ),
      backLayer: _BackLayer(
          maxNumberOfPlayers: maxNumberOfPlayers,
          numberOfPlayers: numberOfPlayers,
          category: category,
          serverName: serverName,
          numberOfQuestions: numberOfQuestions,
          answerTimeLimit: answerTimeLimit),
      frontLayer: Scaffold(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Server name: ' + serverName),
          Text('Question category: ' + category),
          Text('Number of questions: ' + numberOfQuestions.toString()),
          Text('Time for an answer: ' + answerTimeLimit.toString()),
          Text('Game`s attendance: ' + '$numberOfPlayers/$maxNumberOfPlayers'),
        ],
      ),
    );
  }
}
