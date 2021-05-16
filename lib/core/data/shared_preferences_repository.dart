import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  final SharedPreferences prefs;

  SharedPreferencesRepository(this.prefs);

  String? get playerName => prefs.getString('playerName');

  bool? get isSfxEnabled => prefs.getBool('isSfxEnabled');

  bool? get isMusicEnabled => prefs.getBool('isMusicEnabled');

  int? get playerId => prefs.getInt('playerId');

  set isMusicEnabled(bool? isMusicEnabled) => prefs.setBool('isMusicEnabled', isMusicEnabled ?? true);

  set isSfxEnabled(bool? isSfxEnabled) => prefs.setBool('isSfxEnabled', isSfxEnabled ?? true);

  set playerName(String? playerName) => prefs.setString('playerName', playerName ?? '');

  set playerId(int? playerId) => prefs.setInt('playerId', playerId ?? 0);
}
