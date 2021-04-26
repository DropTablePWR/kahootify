part of 'game_config_page_bloc.dart';

@immutable
abstract class GameConfigPageState {}

class GameConfigPageInitial extends GameConfigPageState {}

class GameConfigPageLoading extends GameConfigPageState {}

class GameConfigPageReady extends GameConfigPageState {
  final List<Category> categoriesToChoose;

  GameConfigPageReady(this.categoriesToChoose);
}

class GameConfigPageError extends GameConfigPageState {
  final String errorMessage;

  GameConfigPageError(this.errorMessage);
}
