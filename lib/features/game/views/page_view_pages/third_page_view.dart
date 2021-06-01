import 'package:flutter/material.dart';
import 'package:kahootify/features/game/views/widgets.dart';

class ThirdPageView extends StatelessWidget {
  const ThirdPageView({
    Key? key,
    required this.orientation,
    required this.numberOfResults,
    required this.scores,
    required this.nicks,
    required this.questionNumber,
  }) : super(key: key);

  final Orientation orientation;
  final int numberOfResults;
  final List scores;
  final List nicks;
  final int questionNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: orientation == Orientation.portrait ? const EdgeInsets.symmetric(horizontal: 32) : const EdgeInsets.symmetric(horizontal: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ShowText(
                      text: 'SCOREBOARD AFTER QUESTION: ' + questionNumber.toString(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numberOfResults,
                  itemBuilder: (BuildContext context, int index) {
                    return ResultListItem(score: scores[index], nick: nicks[index]);
                  }),
            )
          ],
        ));
  }
}
