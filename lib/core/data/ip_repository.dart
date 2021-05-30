import 'package:flutter/foundation.dart';
import 'package:wifi_iot/wifi_iot.dart';

class IpRepository {
  static Future<String?> getIp() async {
    if (kIsWeb) {
      return Future.value('192.168.1.0');
    }
    var ip = await WiFiForIoTPlugin.getIP();
    if (ip != null && ip == '0.0.0.0') return null;
    return ip;
  }
}
