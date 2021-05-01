import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:kahootify/const.dart';
import 'package:kahootify/core/models/errors.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:kahootify/core/utils/network_analyzer.dart';
import 'package:wifi_iot/wifi_iot.dart';

class ServerDiscoveryRepository {
  StreamController<String> _controller = StreamController<String>();

  ServerDiscoveryRepository() {
    startDiscovery();
  }

  Stream<String> get serverDiscovery {
    return _controller.stream;
  }

  void startDiscovery() async {
    final myIp = await WiFiForIoTPlugin.getIP();
    if (myIp == null) {
      print("Discovery error");
      return;
    }
    final mySubnet = myIp.substring(0, myIp.lastIndexOf("."));
    final discoveryStream = NetworkAnalyzer.discover(mySubnet, kDefaultServerPort);
    discoveryStream.listen((NetworkAddress address) {
      if (address.exists) {
        _controller.add(address.ip);
      }
    }).onDone(() {
      print("Trzeba to będzie jeszcze powtórzyć");
    });
  }

  Future<Either<ServerConnectionError, ServerInfo>> getServerInfo(String serverIp) async {
    return Right(
      ServerInfo(
        ip: serverIp,
        name: "serverTest",
        maxNumberOfPlayers: 6,
        currentNumberOfPlayers: 2,
        serverStatus: ServerStatus.lobby,
      ),
    ); //TODO remove when actual endpoint available
    /*Uri uri;
    uri = Uri.http(serverIp, "info");
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      return Left(ServerConnectionError());
    }
    var data = jsonDecode(response.body);
    return Right(ServerInfo.fromJson(serverIp, data));*/
  }
}
