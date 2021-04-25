import 'dart:convert';

import 'package:web_socket_channel/io.dart';

// Test player
main() {
  var socket = IOWebSocketChannel.connect("ws://localhost:6666/");
  socket.sink.add(jsonEncode({'id': 6}));
  socket.stream.listen((event) {
    print(event);
  });
}
