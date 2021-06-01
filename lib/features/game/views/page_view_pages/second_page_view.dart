import 'package:flutter/material.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/features/game/views/game_page.dart';
import 'package:kahootify/features/game/views/widgets.dart';
import 'package:kahootify_server/models/question.dart';
import 'package:kahootify_server/models/quiz_question.dart';
import 'package:kahootify_server/models/server_info.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({required this.serverInfo, required this.quizQuestion, required this.questionNumber});

  final ServerInfo serverInfo;
  final QuizQuestion quizQuestion;
  final int questionNumber;

  List<Widget> getAnswerButtonList() {
    return List.generate(4, (index) {
      return AnswerButton(
        index: index,
        buttonState: ButtonState.values[index],
        answer: quizQuestion.possibleAnswers[index],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: orientation == Orientation.portrait
              ? Column(children: [
                  QuestionInfoRow(questionNumber: questionNumber, questionDifficulty: quizQuestion.difficulty),
                  SizedBox(height: 20),
                  CircularCountdown(time: serverInfo.answerTimeLimit),
                  Expanded(child: HeaderText(text: quizQuestion.question)),
                  Expanded(
                    child: GridView.count(
                      childAspectRatio: 3 / 2,
                      mainAxisSpacing: 15,
                      crossAxisCount: 2,
                      children: getAnswerButtonList(),
                    ),
                  )
                ])
              : Row(children: [
                  Expanded(
                    flex: 1,
                    child: Column(children: [
                      QuestionInfoRow(questionNumber: questionNumber, questionDifficulty: quizQuestion.difficulty),
                      SizedBox(height: 30),
                      CircularCountdown(time: serverInfo.answerTimeLimit),
                    ]),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(children: [
                      Expanded(flex: 1, child: HeaderText(text: quizQuestion.question)),
                      Expanded(
                        flex: 1,
                        child: GridView.count(
                          childAspectRatio: 4,
                          mainAxisSpacing: 2,
                          crossAxisCount: 2,
                          children: getAnswerButtonList(),
                        ),
                      ),
                    ]),
                  ),
                ]),
        );
      },
    );
  }
}

class QuestionInfoRow extends StatelessWidget {
  const QuestionInfoRow({required this.questionNumber, required this.questionDifficulty});

  final int questionNumber;
  final QuestionDifficulty questionDifficulty;

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Question: ' + questionNumber.toString(),
          style: TextStyle(fontSize: 15, color: KColors.basedBlackColor, fontWeight: FontWeight.bold),
        ),
        Text(
          'Difficulty: ' + questionDifficultyToString(questionDifficulty),
          style: TextStyle(fontSize: 15, color: KColors.basedBlackColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
