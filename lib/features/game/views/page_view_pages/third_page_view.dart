import 'package:flutter/material.dart';
import 'package:kahootify/features/game/views/widgets.dart';
import 'package:kahootify_server/models/player_info.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({required this.questionNumber, required this.results});

  final int questionNumber;
  final List<PlayerInfo> results;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Padding(
          padding: orientation == Orientation.portrait ? const EdgeInsets.symmetric(horizontal: 32) : const EdgeInsets.symmetric(horizontal: 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: HeaderText(text: 'SCOREBOARD AFTER QUESTION: ' + questionNumber.toString()),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: results.length,
                  itemBuilder: (_, int index) => ResultListItem(playerInfo: results[index]),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
