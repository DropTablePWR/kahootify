import 'package:kahootify_server/server.dart';

// Test Server
Future<void> main() async {
  // Isolate
  // var results = await spawnIsolateServer(5);

  // Classic
  var server = Server(5);
  await Future.delayed(Duration(seconds: 30)).then((value) => server.sendDataToAll("test"));
}
