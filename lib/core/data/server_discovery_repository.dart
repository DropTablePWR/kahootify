import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kahootify/const.dart';
import 'package:kahootify/core/models/errors.dart';
import 'package:kahootify/core/utils/network_analyzer.dart';
import 'package:kahootify_server/models/server_info.dart';

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
  final String myIp;

  ServerDiscoveryRepository(this.myIp) {
    startDiscovery();
  }

  Stream<ServerDiscoveryStreamResult> get serverDiscovery {
    return _controller.stream;
  }

  void startDiscovery() async {
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

  static Future<ServerInfo?> getServerInfo(String serverIp) async {
    Uri uri;
    uri = Uri.http('$serverIp:$kDefaultServerPort', "info");
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        return null;
      }

      var data = jsonDecode(response.body);
      return ServerInfo.fromJson(data);
    } catch (e) {
      return null;
    }
  }
}
