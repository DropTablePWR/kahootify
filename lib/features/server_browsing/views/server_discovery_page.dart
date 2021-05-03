import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify/const.dart';
import 'package:kahootify/core/data/server_discovery_repository.dart';
import 'package:kahootify/features/server_browsing/bloc/server_discovery_bloc.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:web_socket_channel/io.dart';

class ServerDiscoveryPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (context) => ServerDiscoveryPage());
  final ServerDiscoveryRepository serverDiscoveryRepository = ServerDiscoveryRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundLightColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Teraz chcę się połączyć za pomocą qr kodu lub zwykłego kodu");
          //TODO Arkadiusz Mirecki - KAH-28, KAH-12
        },
        child: const Icon(Icons.qr_code, color: kBackgroundLightColor),
        backgroundColor: kBasedBlackColor,
      ),
      body: BlocProvider<ServerDiscoveryBloc>(
        create: (context) => ServerDiscoveryBloc(repository: serverDiscoveryRepository),
        child: _ServerDiscoveryView(),
      ),
    );
  }
}

class _ServerDiscoveryView extends StatelessWidget {
  Widget getBody(ServerDiscoveryState state, BuildContext context) {
    if (state is SearchingErrorState) {
      return Text(state.reason);
    } else if (state is FoundServersState) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          itemCount: state.discoveredServers.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  ListTile(
                    minLeadingWidth: 100,
                    leading: Text(
                      "name: ",
                      style: TextStyle(fontSize: 21, color: kBasedBlackColor),
                    ),
                    title: Text(
                      "players: ",
                      style: TextStyle(fontSize: 21, color: kBasedBlackColor),
                    ),
                    trailing: Text(
                      "status: ",
                      style: TextStyle(fontSize: 21, color: kBasedBlackColor),
                    ),
                  ),
                  _DiscoveredServerListItem(serverInfo: state.discoveredServers[index]),
                ],
              );
            }
            return _DiscoveredServerListItem(serverInfo: state.discoveredServers[index]);
          },
        ),
      );
    } else if (state is! NoServersFound) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: 35),
            Text(
              "No servers found!",
              style: TextStyle(fontSize: 25, color: kBasedBlackColor),
            ),
            SizedBox(height: 35),
            ElevatedButton(
              onPressed: () => context.read<ServerDiscoveryBloc>().add(RefreshRequested()),
              child: Text(
                "REFRESH",
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                primary: kBackgroundGreenColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                elevation: 15,
                padding: EdgeInsets.all(20.0),
                textStyle: TextStyle(color: kBackgroundLightColor),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  List<Widget> getAppBarStatus(ServerDiscoveryState state, BuildContext context) {
    if (state is SearchingErrorState || (state is FoundServersState && !state.stillSearching)) {
      return [
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: IconButton(
            onPressed: () => context.read<ServerDiscoveryBloc>().add(RefreshRequested()),
            icon: Icon(Icons.refresh),
          ),
        )
      ];
    } else {
      return [
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: SpinKitWave(
              color: Colors.white,
              size: 20.0,
            ))
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerDiscoveryBloc, ServerDiscoveryState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: kBackgroundLightColor,
          appBar: AppBar(
            title: Text("AVAILABLE SERVERS"),
            backgroundColor: kBackgroundGreenColor,
            actions: getAppBarStatus(state, context),
          ),
          body: getBody(state, context),
        );
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

  IconData getServerStatus(ServerStatus serverStatus) {
    switch (serverStatus) {
      case ServerStatus.lobby:
        return FontAwesomeIcons.flagCheckered;
      case ServerStatus.inGame:
        return FontAwesomeIcons.gamepad;
      case ServerStatus.results:
        return FontAwesomeIcons.poll;
      default:
        return FontAwesomeIcons.bug;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kBackgroundGreenColor,
      elevation: 10,
      child: SizedBox(
        height: 90.0,
        child: ListTile(
          onTap: connect,
          onLongPress: () {
            Fluttertoast.showToast(
                msg: "Server ip: " + serverInfo.ip,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: kBasedBlackColor,
                textColor: Colors.white,
                fontSize: 16.0);
          },
          minLeadingWidth: 100,
          leading: Container(height: 60, child: Text(serverInfo.name, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
          title: Stack(
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    color: kBasedBlackColor,
                    strokeWidth: 10,
                    value: serverInfo.currentNumberOfPlayers / serverInfo.maxNumberOfPlayers,
                  ),
                ),
              ),
              Center(child: Text("${serverInfo.currentNumberOfPlayers}/${serverInfo.maxNumberOfPlayers}", style: TextStyle(color: Colors.white))),
            ],
          ),
          trailing: Container(
              width: 60,
              height: 60,
              child: FaIcon(
                getServerStatus(serverInfo.serverStatus),
                color: Colors.white,
                size: 50,
              )),
          /*trailing: Text("${serverInfo.currentNumberOfPlayers}/${serverInfo.maxNumberOfPlayers}", style: TextStyle(color: Colors.white)),*/
        ),
      ),
    );
  }
}
