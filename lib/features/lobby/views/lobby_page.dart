import 'dart:async';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/features/lobby/bloc/lobby_page_bloc.dart';
import 'package:kahootify/features/lobby/views/players_list_view.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';

import 'widgets.dart';

class GameArgs {
  final bool amIHost;
  final StreamController serverInput;
  final Stream serverOutput;
  final ServerInfo initialServerInfo;
  final PlayerInfo playerInfo;

  GameArgs({required this.amIHost, required this.serverInput, required this.serverOutput, required this.initialServerInfo, required this.playerInfo});
}

class LobbyPage extends StatelessWidget {
  const LobbyPage(this.args);

  final GameArgs args;

  Widget getFAB(LobbyPageState lobbyPageState) {
    if (args.amIHost) {
      if (lobbyPageState.isStartGameButtonVisible) {
        return StartGameButton();
      }
      return SizedBox.shrink();
    } else {
      return IAmReadyButton(amIReady: lobbyPageState.playerInfo.ready);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LobbyPageBloc>(
      create: (_) => LobbyPageBloc(
        playerInfo: args.playerInfo,
        serverInfo: args.initialServerInfo,
        amIHost: args.amIHost,
        serverOutput: args.serverOutput,
        serverInput: args.serverInput,
      ),
      child: Builder(builder: (context) {
        return BlocConsumer<LobbyPageBloc, LobbyPageState>(
          listener: (context, lobbyPageState) {
            if (lobbyPageState.shouldProceedToGameScreen) {
              Navigator.of(context).pushNamed('/game', arguments: args);
            }
          },
          builder: (context, lobbyPageState) {
            return OrientationBuilder(builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return BackdropScaffold(
                  headerHeight: MediaQuery.of(context).size.height * 0.5,
                  stickyFrontLayer: true,
                  backLayerBackgroundColor: KColors.backgroundGreenColor,
                  backgroundColor: KColors.backgroundLightColor,
                  appBar: BackdropAppBar(
                    title: Text("LOBBY"),
                    backgroundColor: KColors.backgroundGreenColor,
                    actions: [
                      DisplayQRCodeButton(qrCode: lobbyPageState.serverInfo.qrCode, code: lobbyPageState.serverInfo.code),
                    ],
                  ),
                  backLayer: BackLayer(serverInfo: lobbyPageState.serverInfo, isPortrait: true),
                  frontLayer: Scaffold(
                    backgroundColor: KColors.backgroundLightColor,
                    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                    floatingActionButton: getFAB(lobbyPageState),
                    body: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: PlayersListView(
                        playersList: lobbyPageState.playerList.players,
                        maxNumberOfPlayers: lobbyPageState.serverInfo.maxNumberOfPlayers,
                        isHorizontal: false,
                      ),
                    ),
                  ),
                );
              } else {
                return Scaffold(
                  backgroundColor: KColors.backgroundLightColor,
                  appBar: AppBar(
                    title: Text("LOBBY"),
                    backgroundColor: KColors.backgroundGreenColor,
                    actions: [DisplayQRCodeButton(qrCode: lobbyPageState.serverInfo.qrCode, code: lobbyPageState.serverInfo.code)],
                  ),
                  floatingActionButton: getFAB(lobbyPageState),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: PlayersListView(
                            playersList: lobbyPageState.playerList.players,
                            maxNumberOfPlayers: lobbyPageState.serverInfo.maxNumberOfPlayers,
                            isHorizontal: true,
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(bottom: 100),
                            child: SizedBox(
                              width: 200,
                              child: BackLayer(serverInfo: lobbyPageState.serverInfo, isPortrait: false),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            });
          },
        );
      }),
    );
  }
}
