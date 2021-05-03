import 'dart:async';

import 'package:kahootify/const.dart';
import 'package:kahootify/core/models/errors.dart';
import 'package:kahootify/core/utils/network_analyzer.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:wifi_iot/wifi_iot.dart';

abstract class ServerDiscoveryStreamResult {}

class FoundNewServer extends ServerDiscoveryStreamResult {
  final String ip;

  FoundNewServer(this.ip);
}

class EndOfSearch extends ServerDiscoveryStreamResult {}

class ServerDiscoveryErrorResult extends ServerDiscoveryStreamResult {
  final ServerDiscoveryError error;

  ServerDiscoveryErrorResult(this.error);
}

class ServerDiscoveryRepository {
  StreamController<ServerDiscoveryStreamResult> _controller = StreamController<ServerDiscoveryStreamResult>();

  ServerDiscoveryRepository() {
    startDiscovery();
  }

  Stream<ServerDiscoveryStreamResult> get serverDiscovery {
    return _controller.stream;
  }

  void startDiscovery() async {
    final myIp = await WiFiForIoTPlugin.getIP();
    if (myIp == null) {
      _controller.add(ServerDiscoveryErrorResult(NoWifiConnectionError("No WIFI")));
      return;
    }
    final mySubnet = myIp.substring(0, myIp.lastIndexOf("."));
    final discoveryStream = NetworkAnalyzer.discover(mySubnet, kDefaultServerPort);
    discoveryStream.listen((NetworkAddress address) {
      if (address.exists) {
        _controller.add(FoundNewServer(address.ip));
      }
    }).onDone(() {
      _controller.add(EndOfSearch());
    });
  }

  Future<ServerInfo?> getServerInfo(String serverIp) async {
    return ServerInfo(
      ip: serverIp,
      name: "serverTest",
      maxNumberOfPlayers: 6,
      currentNumberOfPlayers: 2,
      serverStatus: ServerStatus.lobby,
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
