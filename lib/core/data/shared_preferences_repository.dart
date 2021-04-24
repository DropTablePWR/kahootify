import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  final SharedPreferences prefs;

  SharedPreferencesRepository(this.prefs);

  String? get playerName => prefs.getString('playerName');

  bool? get enabledSound => prefs.getBool('enabledSound');

  bool? get enabledMusic => prefs.getBool('enabledMusic');

  set enabledMusic(enabledMusic) => prefs.setBool('enabledMusic', enabledMusic);

  set enabledSound(enabledSound) => prefs.setBool('enabledSound', enabledSound);

  set playerName(playerName) => prefs.setString('playerName', playerName);
}
