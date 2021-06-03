import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/const.dart';
import 'package:kahootify/features/game/bloc/bloc.dart';
import 'package:kahootify/features/game/views/widgets.dart';

class CountDownPage extends StatelessWidget {
  const CountDownPage();

  List<Widget> getBody(Orientation orientation, int questionNumber) {
    return [
      Expanded(flex: 3, child: HeaderText(text: 'WAIT FOR $questionNumber QUESTION')),
      Expanded(child: CircularCountdown(time: countdownTime)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamePageBloc, GamePageState>(
      builder: (context, gamePageState) {
        return OrientationBuilder(
          builder: (_, orientation) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: orientation == Orientation.portrait
                  ? Column(
                      children: getBody(orientation, gamePageState.questionNumber),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: getBody(orientation, gamePageState.questionNumber),
                    ),
            );
          },
        );
      },
    );
  }
}
