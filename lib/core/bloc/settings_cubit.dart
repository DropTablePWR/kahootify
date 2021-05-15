import 'package:bloc/bloc.dart';
import 'package:kahootify/core/data/shared_preferences_repository.dart';
import 'package:kahootify/core/models/settings.dart';

class SettingsCubit extends Cubit<Settings> {
  final SharedPreferencesRepository prefs;

  SettingsCubit(this.prefs) : super(Settings.initial());

  void initialize() {
    final String? playerName = prefs.playerName;
    final int? playerId = prefs.playerId;
    final bool? isMusicEnabled = prefs.isMusicEnabled;
    final bool? isSfxEnabled = prefs.isSfxEnabled;
    final initialSettings = Settings.initial().copyWith(playerName: playerName, playerId: playerId, isSfxEnabled: isSfxEnabled, isMusicEnabled: isMusicEnabled);
    emit(initialSettings);
    if (isSfxEnabled == null) {
      prefs.isMusicEnabled = initialSettings.isMusicEnabled;
      prefs.isSfxEnabled = initialSettings.isSfxEnabled;
      prefs.playerId = initialSettings.playerId;
      prefs.playerName = initialSettings.playerName;
    }
  }

  void setPlayerName(String playerName) {
    emit(state.copyWith(playerName: playerName));
    prefs.playerName = playerName;
  }

  void setSfxEnabled({required bool isSfxEnabled}) {
    emit(state.copyWith(isSfxEnabled: isSfxEnabled));
    prefs.isSfxEnabled = isSfxEnabled;
  }

  void setMusicEnabled({required bool isMusicEnabled}) {
    emit(state.copyWith(isMusicEnabled: isMusicEnabled));
    prefs.isMusicEnabled = isMusicEnabled;
  }
}
