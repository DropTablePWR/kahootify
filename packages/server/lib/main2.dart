import 'dart:convert';

import 'package:web_socket_channel/io.dart';

// Test player
main() {
  var socket = IOWebSocketChannel.connect("ws://localhost:6666/");
  socket.sink.add(jsonEncode({'id': 3}));
  socket.stream.listen((event) {
    print(event);
  });

  // while (true) {
  //   Future.delayed(Duration(seconds: 3)).then((value) => socket.sink.add("User"));
  // }
}
