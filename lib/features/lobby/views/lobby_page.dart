import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify/widgets/player_number_indicator.dart';
import 'package:kahootify_server/models/category.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LobbyPage extends StatefulWidget {
  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  List<PlayerInfo> playersList = [
    PlayerInfo(id: 0, name: 'Marek'),
    PlayerInfo(id: 1, name: 'Arek'),
    PlayerInfo(id: 2, name: 'Darek'),
    PlayerInfo(id: 3, name: 'Czarek'),
    PlayerInfo(id: 4, name: 'Artur'),
  ];

  bool iAmReady = true;
  bool isPlayer = true;
  bool allReady = true;

  String qrData = "1234567890";
  final ServerInfo serverInfo = ServerInfo(
    maxNumberOfPlayers: 10,
    numberOfQuestions: 20,
    answerTimeLimit: 13,
    serverStatus: ServerStatus.lobby,
    category: Category(id: 1, name: 'Motoryzacja'),
    currentNumberOfPlayers: 7,
    name: 'server',
    ip: '192.168.1.23',
  );

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
      backLayer: _BackLayer(serverInfo: serverInfo),
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
