import 'package:wifi_iot/wifi_iot.dart';

class IpRepository {
  static Future<String?> getIp() async {
    var ip = await WiFiForIoTPlugin.getIP();
    if (ip != null && ip == '0.0.0.0') return null;
    return ip;
  }
}
