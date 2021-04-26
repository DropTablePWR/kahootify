import 'package:bloc/bloc.dart';
import 'package:kahootify/core/models/api/category.dart';
import 'package:kahootify/features/game_config/models/game_config.dart';

class GameConfigCubit extends Cubit<GameConfig> {
  GameConfigCubit() : super(GameConfig());

  void setGameName(String gameName) => emit(state.copyWith(gameName: gameName));

  void setMaxNumberOfPlayers(int maxNumberOfPlayers) => emit(state.copyWith(maxNumberOfPlayers: maxNumberOfPlayers));

  void setChosenCategory(Category chosenCategory) => emit(state.copyWith(chosenCategory: chosenCategory));

  void setTimeForAnswer(int timeForAnswer) => emit(state.copyWith(timeForAnswer: timeForAnswer));

  void setNumberOfQuestions(int numberOfQuestions) => emit(state.copyWith(numberOfQuestions: numberOfQuestions));
}
