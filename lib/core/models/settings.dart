class Settings {
  String? playerName;
  bool isMusicEnabled;
  bool isSfxEnabled;

  Settings({this.playerName, required this.isMusicEnabled, required this.isSfxEnabled});

  Settings.initial()
      : playerName = null,
        isMusicEnabled = true,
        isSfxEnabled = true;

  Settings copyWith({String? playerName, bool? isMusicEnabled, bool? isSfxEnabled}) {
    return Settings(
      playerName: playerName ?? this.playerName,
      isMusicEnabled: isMusicEnabled ?? this.isMusicEnabled,
      isSfxEnabled: isSfxEnabled ?? this.isSfxEnabled,
    );
  }
}
