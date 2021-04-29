abstract class AbstractPlayer {
  final int playerCode;

  AbstractPlayer(this.playerCode) {
    print("I'm working: " + playerCode.toString());
  }

  void send(dynamic data);

  void reconnect(dynamic data);
}
