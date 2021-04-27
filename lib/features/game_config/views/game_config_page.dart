import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify/const.dart';
import 'package:kahootify/core/models/api/category.dart';
import 'package:kahootify/features/game_config/bloc/game_config_cubit.dart';
import 'package:kahootify/features/game_config/bloc/game_config_page/game_config_page_bloc.dart';
import 'package:kahootify/features/game_config/models/game_config.dart';
import 'package:numberpicker/numberpicker.dart';

class GameConfigPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (context) => GameConfigPage());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GameConfigCubit()),
        BlocProvider(create: (_) => GameConfigPageBloc()..add(GameConfigPageEntered())),
      ],
      child: Scaffold(
        backgroundColor: kBackgroundLightColor,
        appBar: AppBar(
          title: Text(kConfigGame),
          backgroundColor: kBackgroundGreenColor,
        ),
        body: GameConfigPageView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Gotowe i zaakceptowane - przechodzimy do następnego ekranu");
            //TODO tutaj będzię przejście do następnego ekranu, po ustawieniu parametrów gry
          },
          child: const Icon(Icons.check),
          backgroundColor: kBackgroundGreenColor,
        ),
      ),
    );
  }
}

class GameConfigPageView extends StatefulWidget {
  @override
  _GameConfigPageView createState() => _GameConfigPageView();
}

class _GameConfigPageView extends State<GameConfigPageView> {
  late final gameNameInputController;

  @override
  void initState() {
    super.initState();
    gameNameInputController = TextEditingController(text: context.read<GameConfigCubit>().state.gameName);
    gameNameInputController.addListener(_setCurrentGameName);
  }

  @override
  void dispose() {
    gameNameInputController.dispose();
    super.dispose();
  }

  _setCurrentGameName() {
    context.read<GameConfigCubit>().setGameName(gameNameInputController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameConfigPageBloc, GameConfigPageState>(
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
                        Text(
                          gameConfig.gameName,
                          style: TextStyle(fontSize: 25, color: kBasedBlackColor, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 30),
                        TextField(
                          textCapitalization: TextCapitalization.characters,
                          controller: gameNameInputController,
                          cursorColor: kBackgroundGreenColor,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kBackgroundGreenColor),
                            ),
                            labelText: 'Enter your game name',
                            labelStyle: TextStyle(color: kBackgroundGreenColor),
                          ),
                        ),
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
                            print("wybrałeś: " + category.name);
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
