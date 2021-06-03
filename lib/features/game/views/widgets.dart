import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/features/game/bloc/bloc.dart';
import 'package:kahootify/features/game/bloc/game_page_bloc.dart';
import 'package:kahootify/features/game/bloc/game_page_state.dart';
import 'package:kahootify_server/models/player_info.dart';

class CircularCountdown extends StatelessWidget {
  const CircularCountdown({required this.time});

  final int time;

  @override
  Widget build(BuildContext context) {
    return CircularCountDownTimer(
      width: 150,
      height: 150,
      duration: time,
      textFormat: CountdownTextFormat.S,
      ringColor: KColors.backgroundLightColor,
      fillColor: KColors.backgroundGreenColor,
      strokeWidth: 10.0,
      isReverse: true,
      textStyle: TextStyle(fontSize: 35, color: KColors.basedBlackColor),
      onComplete: () => context.read<GamePageBloc>().add(ShowQuestion()),
    );
  }
}

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    required this.buttonState,
  });

  final AnswerButtonState buttonState;

  Color getButtonColor() {
    switch (buttonState.state) {
      case ButtonState.correct:
        return KColors.backgroundGreenColor;
      case ButtonState.incorrect:
        return KColors.basedRedColor;
      case ButtonState.waiting:
        return KColors.basedBlueColor;
      case ButtonState.enabled:
        return KColors.basedOrangeColor;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 120,
        height: 100,
        child: ElevatedButton(
          onPressed: () => context.read<GamePageBloc>().add(AnswerQuestion(buttonState.index)),
          child: FittedBox(fit: BoxFit.fitHeight, child: Text(buttonState.answer)),
          style: ElevatedButton.styleFrom(
            primary: getButtonColor(),
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            elevation: 5,
            padding: const EdgeInsets.all(8),
            textStyle: TextStyle(color: KColors.basedBlackColor, fontSize: 15),
            minimumSize: Size(120, 100),
          ),
        ),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
        child: Text(text, style: TextStyle(fontSize: 35, color: KColors.basedBlackColor)),
      ),
    );
  }
}

class ResultListItem extends StatelessWidget {
  final PlayerInfo playerInfo;
  final int index;

  const ResultListItem({required this.playerInfo, required this.index});

  static const _resultTextStyle = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final int formattedScore = playerInfo.score.toInt() * 100;
    final int myIndex = index + 1;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: KColors.basedBlackColor, width: 1.5),
      ),
      color: KColors.backgroundGreenColor,
      elevation: 10,
      child: SizedBox(
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
                flex: 3,
                child: Text(
                  myIndex.toString() + '. ' + playerInfo.name,
                  style: _resultTextStyle,
                  textAlign: TextAlign.start,
                )),
            Expanded(
                flex: 2,
                child: Text(
                  formattedScore.toString(),
                  style: _resultTextStyle,
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ),
    );
  }
}
