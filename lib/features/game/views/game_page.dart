import 'package:flutter/material.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify_server/models/category.dart';
import 'package:kahootify_server/models/question.dart';
import 'package:kahootify_server/models/quiz_question.dart';
import 'package:kahootify_server/models/server_info.dart';

import 'page_view_pages/first_page_view.dart';
import 'page_view_pages/second_page_view.dart';
import 'page_view_pages/third_page_view.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  final QuizQuestion quizQuestion =
      QuizQuestion('Animals', QuestionDifficulty.easy, 'dokąd nocą tupta jeż?', ['do przedszkola', 'do domu', 'do łóżka', 'o tam tam tam']);

  final ServerInfo serverInfo = ServerInfo(
      code: '1234',
      qrCode: '1234',
      ip: '1234',
      name: 'TEST',
      maxNumberOfPlayers: 10,
      currentNumberOfPlayers: 10,
      serverStatus: ServerStatus.inGame,
      category: Category(id: 1, name: 'Animals'),
      numberOfQuestions: 20,
      answerTimeLimit: 20,
      autoStart: true);

  final int questionNumber = 5;
  final List scores = [35, 25, 10, 3];
  final List nicks = ['Artur', 'Wojtek', 'Joachim', 'Arek'];

  final bool horizontal = false;

  final numberOfResults = 4;

  final List<ButtonState> buttonStates = [ButtonState.disabled, ButtonState.enabled, ButtonState.correct, ButtonState.incorrect];

  @override
  void initState() {
    super.initState();
  }

  Color setButtonState(buttonState) {
    switch (buttonState) {
      case ButtonState.correct:
        return KColors.backgroundGreenColor;
      case ButtonState.incorrect:
        return KColors.basedRedColor;
      case ButtonState.waiting:
        return Colors.grey.shade300;
      case ButtonState.enabled:
        return KColors.basedOrangeColor;
      default:
        return Colors.grey.shade300;
    }
  }

  String getQuestionDiff(QuestionDifficulty questionDifficulty) {
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
    final PageController controller = PageController(initialPage: 0);
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          backgroundColor: KColors.backgroundLightColor,
          appBar: AppBar(
            title: Text('ANSWER THE QUESTION'),
            backgroundColor: KColors.backgroundGreenColor,
          ),
          body: PageView(
            scrollDirection: Axis.horizontal,
            controller: controller,
            children: [
              FirstPageView(orientation: orientation, questionNumber: questionNumber),
              SecondPageView(
                orientation: orientation,
                serverInfo: serverInfo,
                quizQuestion: quizQuestion,
                buttonStates: buttonStates,
                questionNumber: questionNumber,
                getQuestionDiff: getQuestionDiff,
                setButtonState: setButtonState,
              ),
              ThirdPageView(orientation: orientation, numberOfResults: numberOfResults, scores: scores, nicks: nicks, questionNumber: questionNumber),
            ],
          ),
        );
      },
    );
  }
}

enum ButtonState { disabled, enabled, correct, incorrect, waiting }
