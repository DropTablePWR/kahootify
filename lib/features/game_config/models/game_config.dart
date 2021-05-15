import 'package:kahootify_server/models/category.dart';

class GameConfig {
  String gameName;
  int maxNumberOfPlayers;
  Category? category;
  int answerTimeLimit;
  int numberOfQuestions;

  GameConfig({this.gameName = "", this.maxNumberOfPlayers = 5, this.category, this.answerTimeLimit = 15, this.numberOfQuestions = 10});

  GameConfig copyWith({String? gameName, int? maxNumberOfPlayers, Category? category, int? answerTimeLimit, int? numberOfQuestions}) {
    return GameConfig(
      gameName: gameName ?? this.gameName,
      maxNumberOfPlayers: maxNumberOfPlayers ?? this.maxNumberOfPlayers,
      category: category ?? this.category,
      answerTimeLimit: answerTimeLimit ?? this.answerTimeLimit,
      numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
    );
  }
}
