class Settings {
  String? playerName;
  bool enabledMusic;
  bool enabledSound;

  Settings({this.playerName, required this.enabledMusic, required this.enabledSound});

  Settings.initial()
      : playerName = null,
        enabledMusic = true,
        enabledSound = true;

  Settings copyWith({String? playerName, bool? enabledMusic, bool? enabledSound}) {
    return Settings(
      playerName: playerName ?? this.playerName,
      enabledMusic: enabledMusic ?? this.enabledMusic,
      enabledSound: enabledSound ?? this.enabledSound,
    );
  }
}
