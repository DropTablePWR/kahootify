import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  final SharedPreferences prefs;

  SharedPreferencesRepository(this.prefs);

  String? get playerName => prefs.getString('playerName');

  bool? get enabledSound => prefs.getBool('enabledSound');

  bool? get enabledMusic => prefs.getBool('enabledMusic');

  set enabledMusic(bool? enabledMusic) => prefs.setBool('enabledMusic', enabledMusic!);

  set enabledSound(bool? enabledSound) => prefs.setBool('enabledSound', enabledSound!);

  set playerName(String? playerName) => prefs.setString('playerName', playerName!);
}
