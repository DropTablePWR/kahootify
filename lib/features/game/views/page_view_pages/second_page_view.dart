import 'package:flutter/material.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/features/game/views/widgets.dart';
import 'package:kahootify_server/models/quiz_question.dart';
import 'package:kahootify_server/models/server_info.dart';

class SecondPageView extends StatelessWidget {
  const SecondPageView({
    Key? key,
    required this.orientation,
    required this.serverInfo,
    required this.quizQuestion,
    required this.buttonStates,
    required this.questionNumber,
    required this.getQuestionDiff,
    required this.setButtonState,
  }) : super(key: key);

  final Orientation orientation;
  final ServerInfo serverInfo;
  final QuizQuestion quizQuestion;
  final List buttonStates;
  final int questionNumber;
  final Function getQuestionDiff;
  final Function setButtonState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: orientation == Orientation.portrait
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Question: ' + questionNumber.toString(),
                      style: TextStyle(fontSize: 15, color: KColors.basedBlackColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Difficulty: ' + getQuestionDiff(quizQuestion.difficulty),
                      style: TextStyle(fontSize: 15, color: KColors.basedBlackColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CircularCountdown(time: serverInfo.answerTimeLimit),
                Expanded(child: ShowText(text: quizQuestion.question)),
                Expanded(
                  child: GridView.count(
                    childAspectRatio: 3 / 2,
                    mainAxisSpacing: 15,
                    crossAxisCount: 2,
                    children: List.generate(4, (index) {
                      return AnswerButton(
                        index: index,
                        quizQuestion: quizQuestion,
                        setButtonState: (_) => setButtonState(buttonStates[index]),
                        buttonState: buttonStates[index],
                      );
                    }),
                  ),
                )
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Question: ' + questionNumber.toString(),
                            style: TextStyle(fontSize: 15, color: KColors.basedBlackColor, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Difficulty: ' + getQuestionDiff(quizQuestion.difficulty),
                            style: TextStyle(fontSize: 15, color: KColors.basedBlackColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      CircularCountdown(time: serverInfo.answerTimeLimit),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(flex: 1, child: ShowText(text: quizQuestion.question)),
                      Expanded(
                        flex: 1,
                        child: GridView.count(
                          childAspectRatio: 4,
                          mainAxisSpacing: 2,
                          crossAxisCount: 2,
                          children: List.generate(4, (index) {
                            return AnswerButton(
                              index: index,
                              quizQuestion: quizQuestion,
                              setButtonState: (_) => setButtonState(buttonStates[index]),
                              buttonState: buttonStates[index],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
