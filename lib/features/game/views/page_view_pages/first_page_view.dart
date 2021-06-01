import 'package:flutter/material.dart';
import 'package:kahootify/features/game/views/widgets.dart';

class FirstPageView extends StatelessWidget {
  const FirstPageView({
    Key? key,
    required this.orientation,
    required this.questionNumber,
  }) : super(key: key);

  final Orientation orientation;
  final int questionNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: orientation == Orientation.portrait
          ? Column(
              children: [
                SizedBox(height: 60),
                ShowText(text: 'WAIT FOR QUESTION: ' + questionNumber.toString()),
                SizedBox(height: 60),
                CircularCountdown(time: 3),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ShowText(text: 'WAIT FOR ' + questionNumber.toString() + ' QUESTION'),
                SizedBox(height: 60),
                CircularCountdown(time: 3),
              ],
            ),
    );
  }
}
