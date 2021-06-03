import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/features/game/bloc/bloc.dart';
import 'package:kahootify/features/game/views/widgets.dart';
import 'package:kahootify_server/models/question.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamePageBloc, GamePageState>(
      builder: (context, gamePageState) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return Padding(
              padding: const EdgeInsets.only(top: 20, right: 32, left: 32),
              child: orientation == Orientation.portrait
                  ? Column(children: [
                      QuestionInfoRow(),
                      SizedBox(height: 20),
                      CircularCountdown(time: gamePageState.serverInfo.answerTimeLimit),
                      Expanded(child: HeaderText(text: gamePageState.quizQuestion?.question ?? '')),
                      SizedBox(height: 20),
                      Expanded(flex: 3, child: Center(child: AnswerButtonsGrid(buttonStates: gamePageState.answerButtons)))
                    ])
                  : Row(children: [
                      Expanded(
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
                          Expanded(child: HeaderText(text: gamePageState.quizQuestion?.question ?? '')),
                          SizedBox(height: 20),
                          Expanded(flex: 2, child: AnswerButtonsGrid(buttonStates: gamePageState.answerButtons)),
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

class AnswerButtonsGrid extends StatelessWidget {
  final List<AnswerButtonState> buttonStates;

  const AnswerButtonsGrid({required this.buttonStates});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = constraints.biggest.shortestSide;
      return GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: size / 2,
        ),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: List.generate(buttonStates.length, (index) => AnswerButton(buttonState: buttonStates[index], isLeft: index % 2 == 0)),
      );
    });
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
                'Question: ${gamePageState.questionNumber}',
                style: TextStyle(fontSize: 15, color: KColors.basedBlackColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 20),
              Text(
                'Difficulty:' + questionDifficultyToString(gamePageState.quizQuestion?.difficulty ?? QuestionDifficulty.medium),
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
