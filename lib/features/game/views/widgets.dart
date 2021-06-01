import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/features/game/views/game_page.dart';
import 'package:kahootify_server/models/quiz_question.dart';

class CircularCountdown extends StatelessWidget {
  const CircularCountdown({
    Key? key,
    required this.time,
  }) : super(key: key);

  final int time;

  @override
  Widget build(BuildContext context) {
    return CircularCountDownTimer(
      width: 150,
      height: 150,
      duration: time,
      textFormat: CountdownTextFormat.S,
      initialDuration: 0,
      ringColor: KColors.backgroundLightColor,
      ringGradient: null,
      fillColor: KColors.backgroundGreenColor,
      fillGradient: null,
      strokeWidth: 10.0,
      isReverse: true,
      isReverseAnimation: false,
      isTimerTextShown: true,
      textStyle: TextStyle(fontSize: 35, color: KColors.basedBlackColor),
      onStart: () {
        print("czas start");
      },
      onComplete: () {
        print("czas stop");
      },
    );
  }
}

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    Key? key,
    required this.index,
    required this.quizQuestion,
    required this.setButtonState(index),
    required this.buttonState,
  }) : super(key: key);

  final int index;
  final QuizQuestion quizQuestion;
  final Function(ButtonState) setButtonState;
  final ButtonState buttonState;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          buttonState == ButtonState.disabled ? null : print('odpowiedź: ' + index.toString() + ' - ' + quizQuestion.toString());
        },
        child: Text(quizQuestion.possibleAnswers[index]),
        style: ElevatedButton.styleFrom(
            primary: setButtonState(buttonState),
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            elevation: 5,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            textStyle: TextStyle(color: KColors.basedBlackColor, fontSize: 15),
            minimumSize: Size(140, 120)),
      ),
    );
  }
}

class ShowText extends StatelessWidget {
  const ShowText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            text,
            style: TextStyle(fontSize: 25, color: KColors.basedBlackColor),
          ),
        ],
      ),
    );
  }
}

class ResultListItem extends StatelessWidget {
  final int score;
  final String nick;

  const ResultListItem({Key? key, required this.score, required this.nick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: KColors.basedBlackColor,
          width: 1.5,
        ),
      ),
      color: KColors.backgroundGreenColor,
      elevation: 10,
      child: SizedBox(
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(child: Text(nick, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
            Container(child: Text(score.toString(), style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
