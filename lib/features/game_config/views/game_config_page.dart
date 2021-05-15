import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify/core/bloc/settings_cubit.dart';
import 'package:kahootify/features/game_config/bloc/game_config_cubit.dart';
import 'package:kahootify/features/game_config/bloc/game_config_page/game_config_page_bloc.dart';
import 'package:kahootify/features/game_config/models/game_config.dart';
import 'package:kahootify/features/lobby/views/lobby_page.dart';
import 'package:kahootify/widgets/text_fields/default_text_field.dart';
import 'package:kahootify_server/models/category.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:kahootify_server/server.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:wifi_iot/wifi_iot.dart';

class GameConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GameConfigCubit()),
        BlocProvider(create: (_) => GameConfigPageBloc()..add(GameConfigPageEntered())),
      ],
      child: _GameConfigPage(),
    );
  }
}

class _GameConfigPage extends StatefulWidget {
  @override
  _GameConfigPageState createState() => _GameConfigPageState();
}

class _GameConfigPageState extends State<_GameConfigPage> {
  late final gameNameInputController;
  final serverInput = StreamController();

  @override
  void initState() {
    super.initState();
    gameNameInputController = TextEditingController(text: context.read<GameConfigCubit>().state.gameName);
    gameNameInputController.addListener(_setCurrentGameName);
  }

  @override
  void dispose() {
    gameNameInputController.dispose();
    serverInput.close();
    super.dispose();
  }

  _setCurrentGameName() {
    context.read<GameConfigCubit>().setGameName(gameNameInputController.text);
  }

  Future<void> startServer(BuildContext context, GameConfig config) async {
    final serverOutput = StreamController();
    final myIp = await WiFiForIoTPlugin.getIP();
    if (myIp != null && myIp != '0.0.0.0') {
      final serverInfo = ServerInfo.init(
        name: config.gameName,
        maxNumberOfPlayers: config.maxNumberOfPlayers,
        category: config.category!,
        answerTimeLimit: config.answerTimeLimit,
        numberOfQuestions: config.numberOfQuestions,
        ip: myIp,
      );
      final playerInfo = PlayerInfo(id: 0, name: context.read<SettingsCubit>().prefs.playerName ?? 'randomName');
      final results = await spawnIsolateServer(serverInfo, serverOutput, playerInfo);
      SendPort sendPort = results.item2;
      serverInput.stream.listen((data) => sendPort.send(data));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LobbyPage(
            isHost: true,
            input: serverInput,
            output: serverOutput.stream,
            initialServerInfo: serverInfo,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundLightColor,
      appBar: AppBar(
        title: Text("GAME CONFIGURATION"),
        backgroundColor: kBackgroundGreenColor,
      ),
      floatingActionButton: BlocBuilder<GameConfigCubit, GameConfig>(
        builder: (context, config) {
          if (config.gameName.isNotEmpty && config.category != null) {
            return FloatingActionButton(
              onPressed: () => startServer(context, config),
              child: const Icon(Icons.check),
              backgroundColor: kBackgroundGreenColor,
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
      body: BlocBuilder<GameConfigPageBloc, GameConfigPageState>(
        builder: (context, pageState) {
          if (pageState is GameConfigPageError) {
            return Center(
              child: Text(pageState.errorMessage),
            );
          } else if (pageState is GameConfigPageReady) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    SizedBox(height: 35),
                    BlocBuilder<GameConfigCubit, GameConfig>(
                      builder: (context, gameConfig) {
                        return Column(children: [
                          Text(gameConfig.gameName, style: TextStyle(fontSize: 25, color: kBasedBlackColor, fontWeight: FontWeight.bold)),
                          SizedBox(height: 30),
                          DefaultTextField(label: 'Enter your game name', controller: gameNameInputController),
                          SizedBox(height: 35),
                          DropdownButtonFormField<Category>(
                            value: gameConfig.category,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: kBasedBlackColor),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kBackgroundGreenColor),
                              ),
                              labelText: 'Select a category',
                              labelStyle: TextStyle(color: kBackgroundGreenColor),
                            ),
                            onChanged: (Category? category) {
                              context.read<GameConfigCubit>().setCategory(category!);
                            },
                            items: pageState.availableCategories.map((category) {
                              return DropdownMenuItem(
                                child: Text(category.name),
                                value: category,
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 35),
                          _GameConfigNumberPicker(
                            minValue: 2,
                            maxValue: 10,
                            step: 1,
                            value: gameConfig.maxNumberOfPlayers,
                            text: "Maximum number of players: ",
                            onChanged: (value) => context.read<GameConfigCubit>().setMaxNumberOfPlayers(gameConfig.maxNumberOfPlayers),
                          ),
                          SizedBox(height: 35),
                          _GameConfigNumberPicker(
                            minValue: 2,
                            maxValue: 50,
                            step: 1,
                            value: gameConfig.numberOfQuestions,
                            text: "Number of Questions: ",
                            onChanged: (value) => context.read<GameConfigCubit>().setNumberOfQuestions(gameConfig.numberOfQuestions),
                          ),
                          SizedBox(height: 35),
                          _GameConfigNumberPicker(
                            minValue: 10,
                            maxValue: 30,
                            step: 5,
                            value: gameConfig.answerTimeLimit,
                            text: "Seconds to answer: ",
                            onChanged: (value) => context.read<GameConfigCubit>().setAnswerTimeLimit(gameConfig.answerTimeLimit),
                          ),
                        ]);
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class _GameConfigNumberPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int value;
  final int step;
  final String text;
  final Function(int) onChanged;

  const _GameConfigNumberPicker({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.text,
    required this.step,
    required this.onChanged,
  }) : super(key: key);

  @override
  _GameConfigNumberPickerState createState() => _GameConfigNumberPickerState();
}

class _GameConfigNumberPickerState extends State<_GameConfigNumberPicker> {
  int _value = 0;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.text,
            style: TextStyle(
              color: kBackgroundGreenColor,
              fontSize: 15,
            ),
          ),
        ),
        SizedBox(height: 8),
        NumberPicker(
          value: _value,
          minValue: widget.minValue,
          maxValue: widget.maxValue,
          step: widget.step,
          onChanged: (newValue) {
            setState(() {
              _value = newValue;
            });
            widget.onChanged(newValue);
          },
          axis: Axis.horizontal,
          textStyle: TextStyle(fontSize: 25, color: kBasedBlackColor),
          selectedTextStyle: TextStyle(fontSize: 25, color: kBackgroundGreenColor, fontWeight: FontWeight.bold),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kBackgroundGreenColor),
          ),
        ),
      ],
    );
  }
}
