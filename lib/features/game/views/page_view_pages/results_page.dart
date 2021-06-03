import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/features/game/bloc/bloc.dart';
import 'package:kahootify/features/game/views/widgets.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamePageBloc, GamePageState>(
      builder: (context, gamePageState) {
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
                          child: HeaderText(text: 'SCOREBOARD AFTER QUESTION: ' + gamePageState.questionNumber.toString()),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: gamePageState.results.length,
                      itemBuilder: (_, int index) => ResultListItem(playerInfo: gamePageState.results[index]),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
