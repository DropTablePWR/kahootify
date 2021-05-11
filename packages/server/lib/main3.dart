import 'package:kahootify_server/utils/code_converter.dart';

main() {
  var code = CodeConverter.encodeIpAsQrCode("001.018");
  print("CODE: $code");
  if (code == null) return;
  var ip = CodeConverter.decodeIpFromQrCode(code);
  print("IP: $ip");
}
