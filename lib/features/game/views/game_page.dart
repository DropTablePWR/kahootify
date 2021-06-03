import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/features/game/bloc/bloc.dart';
import 'package:kahootify/features/game/bloc/game_page_bloc.dart';
import 'package:kahootify/features/game/bloc/game_page_state.dart';
import 'package:kahootify/features/game/views/page_view_pages/get_ready_page.dart';
import 'package:kahootify_server/models/server_info.dart';

import 'page_view_pages/count_down_page.dart';
import 'page_view_pages/question_page.dart';
import 'page_view_pages/results_page.dart';

class GamePage extends StatelessWidget {
  final ServerInfo initialServerInfo;
  final Stream serverOutput;
  final StreamController serverInput;

  GamePage({required this.initialServerInfo, required this.serverOutput, required this.serverInput});

  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GamePageBloc>(
      create: (context) => GamePageBloc(serverInfo: initialServerInfo, serverInput: serverInput, serverOutput: serverOutput),
      child: OrientationBuilder(
        builder: (context, orientation) {
          return BlocListener<GamePageBloc, GamePageState>(
            listener: (context, gamePageState) {
              if (gamePageState.currentPage != controller.page) {
                controller.animateToPage(gamePageState.currentPage, curve: Curves.easeInCubic, duration: 200.milliseconds);
              }
              if (gamePageState.shouldProceedToResultsScreen) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResultsPage()));
              }
            },
            child: Scaffold(
              backgroundColor: KColors.backgroundLightColor,
              appBar: AppBar(
                title: Text('ANSWER THE QUESTION'),
                backgroundColor: KColors.backgroundGreenColor,
              ),
              body: PageView(
                controller: controller,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  GetReadyPage(),
                  CountDownPage(),
                  QuestionPage(),
                  ResultsPage(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
