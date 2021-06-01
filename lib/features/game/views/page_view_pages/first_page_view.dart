import 'package:flutter/material.dart';
import 'package:kahootify/features/game/views/widgets.dart';

class CountDownPage extends StatelessWidget {
  const CountDownPage({required this.questionNumber});

  final int questionNumber;

  List<Widget> getBody(Orientation orientation) {
    return [
      if (orientation == Orientation.portrait) SizedBox(height: 60),
      HeaderText(text: 'WAIT FOR ' + questionNumber.toString() + ' QUESTION'),
      SizedBox(height: 60),
      CircularCountdown(time: 3),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: orientation == Orientation.portrait
              ? Column(children: getBody(orientation))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: getBody(orientation),
                ),
        );
      },
    );
  }
}
