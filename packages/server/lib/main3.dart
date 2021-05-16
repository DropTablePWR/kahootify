import 'package:kahootify_server/utils/code_converter.dart';

main() {
  var code = CodeConverter.encodeIp("001.162");
  print("CODE: $code");
  if (code == null) return;
  var ip = CodeConverter.decodeIpFromQrCode(code);
  print("IP: $ip");
}
