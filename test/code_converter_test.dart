import 'package:flutter_test/flutter_test.dart';
import 'package:kahootify_server/utils/code_converter.dart';

main() {
  test('Ip should be correctly encoded and decoded', () {
    for (var i = 0; i < 255; i++) {
      for (var j = 0; j < 255; j++) {
        var ip = i.toString().padLeft(3, '0');
        ip += '.';
        ip += j.toString().padLeft(3, '0');
        var code = CodeConverter.encodeIp(ip);
        expect(code, isNotNull);
        if (code != null) {
          var decodedIp = CodeConverter.decodeIp(code);
          expect(decodedIp, isNotNull);
          if (decodedIp != null) {
            //print("i: $i j: $j ip:$ip result:$decodedIp");
            expect(decodedIp, ip);
          }
        }
      }
    }
  });
  test('Ip should be correctly encoded and decoded as QRCODE', () {
    for (var i = 0; i < 255; i++) {
      for (var j = 0; j < 255; j++) {
        var ip = i.toString().padLeft(3, '0');
        ip += '.';
        ip += j.toString().padLeft(3, '0');
        var code = CodeConverter.encodeIpAsQrCode(ip);
        expect(code, isNotNull);
        if (code != null) {
          var decoded = CodeConverter.decodeIpFromQrCode(code);
          expect(decoded, isNotNull);
          if (decoded != null) {
            //print("i: $i j: $j ip:$ip result:$decodedIp");
            expect(decoded, ip);
          }
        }
      }
    }
  });
}
