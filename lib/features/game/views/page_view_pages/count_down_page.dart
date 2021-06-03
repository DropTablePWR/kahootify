import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/const.dart';
import 'package:kahootify/features/game/bloc/bloc.dart';
import 'package:kahootify/features/game/views/widgets.dart';

class CountDownPage extends StatelessWidget {
  final GlobalKey countDownPageTimer = GlobalKey();

  List<Widget> getBody(Orientation orientation, int questionNumber, BuildContext context) {
    return [
      Expanded(flex: 3, child: HeaderText(text: 'WAIT FOR $questionNumber QUESTION')),
      Expanded(
        child: CircularCountdown(
          time: countdownTime,
          onComplete: () => context.read<GamePageBloc>().add(ShowQuestion()),
          pageNumberToStartOn: 1,
          key: countDownPageTimer,
        ),
      ),
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
                      children: getBody(orientation, gamePageState.questionNumber, context),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: getBody(orientation, gamePageState.questionNumber, context),
                    ),
            );
          },
        );
      },
    );
  }
}
