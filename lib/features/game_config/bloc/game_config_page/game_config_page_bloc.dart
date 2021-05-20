import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kahootify_server/data/remote_trivia_repository.dart';
import 'package:kahootify_server/models/category.dart';
import 'package:meta/meta.dart';

part 'game_config_page_event.dart';
part 'game_config_page_state.dart';

class GameConfigPageBloc extends Bloc<GameConfigPageEvent, GameConfigPageState> {
  GameConfigPageBloc() : super(GameConfigPageInitial());

  @override
  Stream<GameConfigPageState> mapEventToState(
    GameConfigPageEvent event,
  ) async* {
    if (event is GameConfigPageEntered) {
      yield GameConfigPageLoading();
      final categories = await RemoteTriviaRepository.getAllAvailableCategories();
      yield categories.fold((error) => GameConfigPageError(error.reason), (data) => GameConfigPageReady(data));
    }
  }
}
