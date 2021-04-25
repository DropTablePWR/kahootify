import 'package:bloc/bloc.dart';
import 'package:kahootify/core/data/shared_preferences_repository.dart';
import 'package:kahootify/core/models/settings.dart';

class SettingsCubit extends Cubit<Settings> {
  final SharedPreferencesRepository prefs;

  SettingsCubit(this.prefs) : super(Settings.initial());

  void initialize() {
    final String? playerName = prefs.playerName;
    final bool? enabledMusic = prefs.enabledMusic;
    final bool? enabledSound = prefs.enabledSound;
    emit(Settings.initial().copyWith(playerName: playerName, enabledSound: enabledSound, enabledMusic: enabledMusic));
    if (enabledSound == null) {
      prefs.enabledMusic = true;
      prefs.enabledSound = true;
    }
  }

  void changePlayerName(String playerName) {
    emit(state.copyWith(playerName: playerName));
    prefs.playerName = playerName;
  }

  void toggleSound({required bool enabledSound}) {
    emit(state.copyWith(enabledSound: enabledSound));
    prefs.enabledSound = enabledSound;
  }

  void toggleMusic({required bool enabledMusic}) {
    emit(state.copyWith(enabledMusic: enabledMusic));
    prefs.enabledMusic = enabledMusic;
  }
}
