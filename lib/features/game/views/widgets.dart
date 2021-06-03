import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/features/game/bloc/bloc.dart';
import 'package:kahootify/features/game/bloc/game_page_bloc.dart';
import 'package:kahootify/features/game/bloc/game_page_state.dart';
import 'package:kahootify_server/models/player_info.dart';

class CircularCountdown extends StatefulWidget {
  const CircularCountdown({required Key key, required this.time, required this.pageNumberToStartOn, this.onComplete}) : super(key: key);

  final Function()? onComplete;
  final int time;
  final int pageNumberToStartOn;

  @override
  _CircularCountdownState createState() => _CircularCountdownState();
}

class _CircularCountdownState extends State<CircularCountdown> {
  late CountDownController controller;

  @override
  void initState() {
    controller = CountDownController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GamePageBloc, GamePageState>(
      listener: (context, gamePageState) {
        if (gamePageState.currentPage == widget.pageNumberToStartOn) {
          if (int.parse(controller.getTime()) == widget.time) {
            controller.start();
          }
        } else {
          controller.restart(duration: widget.time);
          controller.pause();
        }
      },
      child: CircularCountDownTimer(
        controller: controller,
        width: 150,
        height: 150,
        duration: widget.time,
        textFormat: CountdownTextFormat.S,
        ringColor: KColors.backgroundLightColor,
        fillColor: KColors.backgroundGreenColor,
        strokeWidth: 10.0,
        isReverse: true,
        textStyle: TextStyle(fontSize: 35, color: KColors.basedBlackColor),
        onComplete: widget.onComplete,
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    required this.buttonState,
    required this.isLeft,
  });

  final AnswerButtonState buttonState;
  final bool isLeft;

  Color _buttonColor() {
    switch (buttonState.state) {
      case ButtonState.correct:
        return KColors.backgroundGreenColor;
      case ButtonState.incorrect:
        return KColors.basedRedColor;
      case ButtonState.waiting:
        return KColors.blueColor;
      case ButtonState.enabled:
        return KColors.basedOrangeColor;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = constraints.biggest.shortestSide;
      return Align(
        alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
        child: SizedBox(
          height: size,
          width: size,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => context.read<GamePageBloc>().add(AnswerQuestion(buttonState.index)),
              child: FittedBox(fit: BoxFit.fitHeight, child: Text(buttonState.answer)),
              style: ElevatedButton.styleFrom(
                primary: _buttonColor(),
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                elevation: 5,
                padding: const EdgeInsets.all(8),
                textStyle: TextStyle(color: KColors.basedBlackColor, fontSize: 15),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
      child: AutoSizeText(text, style: TextStyle(fontSize: 20, color: KColors.basedBlackColor)),
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
    final int formattedScore = (playerInfo.score * 100).toInt();
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
          children: [
            Expanded(child: SizedBox()),
            Expanded(
              flex: 3,
              child: Text('$myIndex.${playerInfo.name}', style: _resultTextStyle, textAlign: TextAlign.start),
            ),
            Expanded(
              flex: 2,
              child: Text(formattedScore.toString(), style: _resultTextStyle, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
