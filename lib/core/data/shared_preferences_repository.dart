import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  final SharedPreferences prefs;

  SharedPreferencesRepository(this.prefs);

  String? get playerName => prefs.getString('playerName');

  bool? get isSfxEnabled => prefs.getBool('isSfxEnabled');

  bool? get isMusicEnabled => prefs.getBool('isMusicEnabled');

  set isMusicEnabled(bool? isMusicEnabled) => prefs.setBool('isMusicEnabled', isMusicEnabled ?? true);

  set isSfxEnabled(bool? isSfxEnabled) => prefs.setBool('isSfxEnabled', isSfxEnabled ?? true);

  set playerName(String? playerName) => prefs.setString('playerName', playerName ?? '');
}
