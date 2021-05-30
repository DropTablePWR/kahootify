import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kahootify_server/data/remote_trivia_repository.dart';
import 'package:kahootify_server/models/category.dart';
import 'package:meta/meta.dart';

class GameConfigPageBloc extends Bloc<GameConfigPageEvent, GameConfigPageState> {
  GameConfigPageBloc() : super(GameConfigPageInitial());

  @override
  Stream<GameConfigPageState> mapEventToState(GameConfigPageEvent event,) async* {
    if (event is GameConfigPageEntered) {
      yield GameConfigPageLoading();
      final categories = await RemoteTriviaRepository.getAllAvailableCategories();
      yield categories.fold((error) => GameConfigPageError(error.reason), (data) => GameConfigPageReady(data));
    }
  }
}

@immutable
abstract class GameConfigPageEvent {}

class GameConfigPageEntered extends GameConfigPageEvent {}

@immutable
abstract class GameConfigPageState {}

class GameConfigPageInitial extends GameConfigPageState {}

class GameConfigPageLoading extends GameConfigPageState {}

class GameConfigPageReady extends GameConfigPageState {
  final List<Category> availableCategories;

  GameConfigPageReady(this.availableCategories);
}

class GameConfigPageError extends GameConfigPageState {
  final String errorMessage;

  GameConfigPageError(this.errorMessage);
}
