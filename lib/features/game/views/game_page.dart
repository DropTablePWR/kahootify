import 'package:flutter/material.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify_server/models/category.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/question.dart';
import 'package:kahootify_server/models/quiz_question.dart';
import 'package:kahootify_server/models/server_info.dart';

import 'page_view_pages/first_page_view.dart';
import 'page_view_pages/second_page_view.dart';
import 'page_view_pages/third_page_view.dart';

class GamePage extends StatelessWidget {
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
    autoStart: true,
  );

  final int questionNumber = 5;
  final List<PlayerInfo> results = [
    PlayerInfo(id: 0, name: 'Artur', score: 10),
    PlayerInfo(id: 1, name: 'Wojtek', score: 20),
    PlayerInfo(id: 2, name: 'Joachim', score: 135),
    PlayerInfo(id: 3, name: 'Arek', score: 125)
  ];

  final bool horizontal = false;

  final numberOfResults = 4;

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
            physics: NeverScrollableScrollPhysics(),
            children: [
              CountDownPage(questionNumber: questionNumber),
              QuestionPage(serverInfo: serverInfo, quizQuestion: quizQuestion, questionNumber: questionNumber),
              ResultsPage(questionNumber: questionNumber, results: results),
            ],
          ),
        );
      },
    );
  }
}

enum ButtonState { disabled, enabled, correct, incorrect, waiting }
