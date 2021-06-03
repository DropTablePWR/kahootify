import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/features/game/views/widgets.dart';
import 'package:kahootify/features/lobby/views/lobby_page.dart';
import 'package:kahootify/features/results/bloc/results_page_bloc.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage(this.args);

  final GameArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResultsPageBloc>(
      create: (_) => ResultsPageBloc(serverInput: args.serverInput, serverOutput: args.serverOutput),
      child: Builder(
        builder: (BuildContext context) {
          return BlocConsumer<ResultsPageBloc, ResultsPageState>(
            listener: (context, resultsPageState) {
              if (resultsPageState.shouldGoBackToLobby) {
                Navigator.of(context).popUntil((route) => route.settings.name == '/lobby');
              }
            },
            builder: (context, resultsPageState) {
              if (resultsPageState.rankingInfo == null) {
                return Scaffold(
                  backgroundColor: KColors.backgroundLightColor,
                  appBar: AppBar(title: Text('And the winner is...'), backgroundColor: KColors.backgroundGreenColor),
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return Scaffold(
                backgroundColor: KColors.backgroundLightColor,
                appBar: AppBar(title: Text('Winner: ${resultsPageState.rankingInfo!.players[0].name}'), backgroundColor: KColors.backgroundGreenColor),
                body: Column(
                  children: [
                    Expanded(child: Center(child: Text('FINAL RESULTS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
                    Expanded(
                      flex: 5,
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 50),
                        itemCount: resultsPageState.rankingInfo!.players.length,
                        itemBuilder: (_, index) => ResultListItem(playerInfo: resultsPageState.rankingInfo!.players[index], index: index, displayBadge: true),
                      ),
                    ),
                  ],
                ),
                floatingActionButton: args.amIHost ? _BackToLobbyButton() : null,
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              );
            },
          );
        },
      ),
    );
  }
}

class _BackToLobbyButton extends StatelessWidget {
  const _BackToLobbyButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: KColors.backgroundGreenColor),
      onPressed: () => context.read<ResultsPageBloc>().add(SendBackToLobby()),
      child: Text('Go back to lobby'),
    );
  }
}
