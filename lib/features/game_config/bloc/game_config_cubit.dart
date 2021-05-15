import 'package:bloc/bloc.dart';
import 'package:kahootify/features/game_config/models/game_config.dart';
import 'package:kahootify_server/models/category.dart';

class GameConfigCubit extends Cubit<GameConfig> {
  GameConfigCubit() : super(GameConfig());

  void setGameName(String gameName) => emit(state.copyWith(gameName: gameName));

  void setMaxNumberOfPlayers(int maxNumberOfPlayers) => emit(state.copyWith(maxNumberOfPlayers: maxNumberOfPlayers));

  void setCategory(Category category) => emit(state.copyWith(category: category));

  void setAnswerTimeLimit(int answerTimeLimit) => emit(state.copyWith(answerTimeLimit: answerTimeLimit));

  void setNumberOfQuestions(int numberOfQuestions) => emit(state.copyWith(numberOfQuestions: numberOfQuestions));
}
