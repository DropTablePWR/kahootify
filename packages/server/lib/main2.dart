import 'dart:convert';

import 'package:web_socket_channel/io.dart';

// Test player
main() async {
  var socket = IOWebSocketChannel.connect("ws://localhost:6666/");
  socket.sink.add(jsonEncode({'id': 1}));
  socket.stream.listen((event) {
    print(event);
  });

  while (true) {
    await Future.delayed(Duration(seconds: 3)).then((value) => socket.sink.add(jsonEncode({'message': "player"})));
  }
}
