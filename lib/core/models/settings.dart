import 'dart:math';

class Settings {
  String playerName;
  int playerId;
  bool isMusicEnabled;
  bool isSfxEnabled;

  Settings({required this.playerName, required this.playerId, required this.isMusicEnabled, required this.isSfxEnabled});

  Settings.initial()
      : playerName = 'Player${Random().nextInt(10000)}',
        playerId = Random().nextInt(100000),
        isMusicEnabled = false,
        isSfxEnabled = false;

  Settings copyWith({String? playerName, bool? isMusicEnabled, bool? isSfxEnabled, int? playerId}) {
    return Settings(
      playerName: playerName ?? this.playerName,
      isMusicEnabled: isMusicEnabled ?? this.isMusicEnabled,
      isSfxEnabled: isSfxEnabled ?? this.isSfxEnabled,
      playerId: playerId ?? this.playerId,
    );
  }
}
