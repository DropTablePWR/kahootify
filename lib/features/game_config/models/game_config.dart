import 'package:kahootify/core/models/api/category.dart';

class GameConfig {
  String gameName;
  int maxNumberOfPlayers;
  Category? chosenCategory;
  int timeForAnswer;
  int numberOfQuestions;

  GameConfig({this.gameName = "", this.maxNumberOfPlayers = 5, this.chosenCategory, this.timeForAnswer = 15, this.numberOfQuestions = 10});

  GameConfig copyWith({String? gameName, int? maxNumberOfPlayers, Category? chosenCategory, int? timeForAnswer, int? numberOfQuestions}) {
    return GameConfig(
      gameName: gameName ?? this.gameName,
      maxNumberOfPlayers: maxNumberOfPlayers ?? this.maxNumberOfPlayers,
      chosenCategory: chosenCategory ?? this.chosenCategory,
      timeForAnswer: timeForAnswer ?? this.timeForAnswer,
      numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
    );
  }
}
