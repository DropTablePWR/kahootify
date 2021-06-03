import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/features/game/bloc/bloc.dart';
import 'package:kahootify/features/game/bloc/game_page_bloc.dart';
import 'package:kahootify/features/game/bloc/game_page_state.dart';
import 'package:kahootify/features/game/views/page_view_pages/get_ready_page.dart';
import 'package:kahootify/features/lobby/views/lobby_page.dart';

import 'page_view_pages/count_down_page.dart';
import 'page_view_pages/question_page.dart';
import 'page_view_pages/small_results_page.dart';

class GamePage extends StatelessWidget {
  GamePage(this.args);

  final GameArgs args;
  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GamePageBloc>(
      create: (context) => GamePageBloc(serverInfo: args.initialServerInfo, serverInput: args.serverInput, serverOutput: args.serverOutput),
      child: Builder(
        builder: (context) {
          return BlocListener<GamePageBloc, GamePageState>(
            listener: (context, gamePageState) {
              if (gamePageState.currentPage != controller.page) {
                controller.animateToPage(gamePageState.currentPage, curve: Curves.easeInCubic, duration: 200.milliseconds);
              }
              if (gamePageState.shouldProceedToResultsScreen) {
                Navigator.of(context).pushReplacementNamed('/results', arguments: args);
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
                  SmallResultsPage(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
