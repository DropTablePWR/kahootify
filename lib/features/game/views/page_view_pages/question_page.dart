import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/features/game/bloc/bloc.dart';
import 'package:kahootify/features/game/views/widgets.dart';
import 'package:kahootify_server/models/question.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage();

  List<Widget> getAnswerButtonList(List<AnswerButtonState> buttonStates) {
    return List.generate(buttonStates.length, (index) => AnswerButton(buttonState: buttonStates[index]));
  }

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
                      SizedBox(height: 20),
                      QuestionInfoRow(),
                      SizedBox(height: 20),
                      CircularCountdown(time: gamePageState.serverInfo.answerTimeLimit),
                      Expanded(flex: 1, child: HeaderText(text: gamePageState.quizQuestion?.question ?? '')),
                      Expanded(
                        flex: 4,
                        child: GridView.count(
                          physics: NeverScrollableScrollPhysics(),
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
                          SizedBox(height: 20),
                          QuestionInfoRow(),
                          SizedBox(height: 30),
                          CircularCountdown(time: gamePageState.serverInfo.answerTimeLimit),
                        ]),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(children: [
                          Expanded(flex: 1, child: HeaderText(text: gamePageState.quizQuestion?.question ?? '')),
                          Expanded(
                            flex: 3,
                            child: GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              childAspectRatio: 3,
                              shrinkWrap: true,
                              mainAxisSpacing: 10,
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

  Color questionDifficultyColor(QuestionDifficulty questionDifficulty) {
    switch (questionDifficulty) {
      case QuestionDifficulty.easy:
        return KColors.basedYellowColor;
      case QuestionDifficulty.medium:
        return KColors.basedOrangeColor;
      case QuestionDifficulty.hard:
        return KColors.basedRedColor;
      default:
        return KColors.basedBlackColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamePageBloc, GamePageState>(
      builder: (context, gamePageState) {
        return FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Question: ' + gamePageState.questionNumber.toString(),
                style: TextStyle(fontSize: 15, color: KColors.basedBlackColor, fontWeight: FontWeight.bold),
              ),
              Text(
                '  Difficulty: ' + questionDifficultyToString(gamePageState.quizQuestion?.difficulty ?? QuestionDifficulty.medium),
                style: TextStyle(
                    fontSize: 15,
                    color: questionDifficultyColor(gamePageState.quizQuestion?.difficulty ?? QuestionDifficulty.medium),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
