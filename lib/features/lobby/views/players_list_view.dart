import 'package:flutter/material.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify_server/models/player_info.dart';

class PlayersListView extends StatelessWidget {
  const PlayersListView({Key? key, required this.maxNumberOfPlayers, required this.playersList, required this.isHorizontal}) : super(key: key);

  final int maxNumberOfPlayers;
  final List<PlayerInfo> playersList;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: maxNumberOfPlayers,
      padding: EdgeInsets.only(top: 35, bottom: isHorizontal ? 35 : 100),
      itemBuilder: (BuildContext context, int index) {
        if (index < playersList.length) {
          return _PlayersListItem(playerInfo: playersList[index]);
        }
        return _PlayersListItem();
      },
    );
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
