import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/const.dart';
import 'package:kahootify/core/data/server_discovery_repository.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:kahootify/features/server_browsing/bloc/server_discovery_bloc.dart';
import 'package:web_socket_channel/io.dart';

class ServerDiscoveryPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (context) => ServerDiscoveryPage());
  final ServerDiscoveryRepository serverDiscoveryRepository = ServerDiscoveryRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ServerDiscoveryBloc>(
        create: (context) => ServerDiscoveryBloc(repository: serverDiscoveryRepository),
        child: _ServerDiscoveryView(),
      ),
    );
  }
}

class _ServerDiscoveryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerDiscoveryBloc, ServerDiscoveryState>(
      builder: (context, state) {
        if (state is SearchingError) {
          return Text("error");
        } else if (state is FoundServers) {
          return ListView.builder(
            itemCount: state.discoveredServers.length,
            itemBuilder: (context, index) => _DiscoveredServerListItem(serverInfo: state.discoveredServers[index]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _DiscoveredServerListItem extends StatelessWidget {
  final ServerInfo serverInfo;

  const _DiscoveredServerListItem({required this.serverInfo});

  void connect() async {
    var socket = IOWebSocketChannel.connect("ws://${serverInfo.ip}:$kDefaultServerPort/");
    socket.sink.add(jsonEncode({'id': 1}));
    socket.stream.listen((event) {
      print(event);
    });

    while (true) {
      await Future.delayed(Duration(seconds: 3)).then((value) => socket.sink.add(jsonEncode({'message': "player"})));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: connect,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(serverInfo.name),
          Text(serverInfo.ip),
          Text(serverInfo.serverStatus.toString()),
          Text("${serverInfo.currentNumberOfPlayers}/${serverInfo.maxNumberOfPlayers}"),
        ],
      ),
    );
  }
}
