import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/features/game/bloc/bloc.dart';
import 'package:kahootify/features/game/views/widgets.dart';
import 'package:kahootify_server/models/question.dart';

class QuestionPage extends StatelessWidget {
  List<Widget> getAnswerButtonList(List<AnswerButtonState> buttonStates) {
    return List.generate(buttonStates.length, (index) => AnswerButton(buttonState: buttonStates[index]));
  }

  final GlobalKey questionPageTimerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamePageBloc, GamePageState>(
      builder: (context, gamePageState) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: orientation == Orientation.portrait
                  ? Column(children: [
                      QuestionInfoRow(),
                      SizedBox(height: 20),
                      CircularCountdown(time: gamePageState.serverInfo.answerTimeLimit, pageNumberToStartOn: 2, key: questionPageTimerKey),
                      Expanded(child: HeaderText(text: gamePageState.quizQuestion?.question ?? '')),
                      Expanded(
                        child: GridView.count(
                          childAspectRatio: 3 / 2,
                          mainAxisSpacing: 15,
                          crossAxisCount: 2,
                          children: getAnswerButtonList(gamePageState.answerButtons),
                        ),
                      )
                    ])
                  : Row(children: [
                      Expanded(
                        flex: 1,
                        child: Column(children: [
                          QuestionInfoRow(),
                          SizedBox(height: 30),
                          CircularCountdown(time: gamePageState.serverInfo.answerTimeLimit, pageNumberToStartOn: 2, key: questionPageTimerKey),
                        ]),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(children: [
                          Expanded(flex: 1, child: HeaderText(text: gamePageState.quizQuestion?.question ?? '')),
                          Expanded(
                            flex: 1,
                            child: GridView.count(
                              childAspectRatio: 4,
                              mainAxisSpacing: 2,
                              crossAxisCount: 2,
                              children: getAnswerButtonList(gamePageState.answerButtons),
                            ),
                          ),
                        ]),
                      ),
                    ]),
            );
          },
        );
      },
    );
  }
}

class QuestionInfoRow extends StatelessWidget {
  const QuestionInfoRow();

  String questionDifficultyToString(QuestionDifficulty questionDifficulty) {
    switch (questionDifficulty) {
      case QuestionDifficulty.easy:
        return 'EASY';
      case QuestionDifficulty.medium:
        return 'MEDIUM';
      case QuestionDifficulty.hard:
        return 'HARD';
      default:
        return '----';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamePageBloc, GamePageState>(
      builder: (context, gamePageState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Question: ' + gamePageState.questionNumber.toString(),
              style: TextStyle(fontSize: 15, color: KColors.basedBlackColor, fontWeight: FontWeight.bold),
            ),
            Text(
              'Difficulty: ' + questionDifficultyToString(gamePageState.quizQuestion?.difficulty ?? QuestionDifficulty.medium),
              style: TextStyle(fontSize: 15, color: KColors.basedBlackColor, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }
}
