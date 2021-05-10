import 'dart:convert';
import 'dart:core';
import 'dart:math';

class CodeConverter {
  CodeConverter._();

  static String? decodeIp(String code) {
    if (code.length != 6) {
      print("bad code length ${code.length}");
      return null;
    }
    String ip = "";
    int sum = 0;
    var codeAsInt = _ipToInt(code);
    if (codeAsInt == null) return null;
    if (codeAsInt[0] > 2) {
      ip += "0";
    } else {
      ip += code[0];
      sum += codeAsInt[0];
    }
    ip += code[1];
    sum += codeAsInt[1];
    ip += code[2];
    sum += codeAsInt[2];
    ip += ".";
    if (codeAsInt[3] > 2) {
      ip += "0";
    } else {
      ip += code[3];
      sum += codeAsInt[3];
    }
    ip += code[4];
    sum += codeAsInt[4];
    var a = codeAsInt[5] - sum;
    while (a < 0) {
      a = 10 + a;
    }
    ip += a.toString();
    return ip;
  }

  static String? encodeIp(String ip) {
    var code = "";
    ip = ip.replaceAll(".", "");
    var ipAsInt = _ipToInt(ip);
    if (ipAsInt == null) return null;
    if (ipAsInt[0] == 0) {
      code += (Random().nextInt(6) + 3).toString();
    } else {
      code += ip[0];
    }
    code += ip[1];
    code += ip[2];
    if (ipAsInt[3] == 0) {
      code += (Random().nextInt(6) + 3).toString();
    } else {
      code += ip[3];
    }
    code += ip[4];

    var sum = 0;
    ipAsInt.forEach((digit) => sum += digit);
    code += (sum % 10).toString();
    return code;
  }

  static String? encodeIpAsQrCode(String ip, {int encodingLevel = 10}) {
    var codedIp = encodeIp(ip);
    if (codedIp == null) return null;
    var encoder = Base64Encoder();
    var encoded = encoder.convert(utf8.encode(codedIp));

    for (var i = 1; i < encodingLevel; i++) {
      encoded = encoder.convert(utf8.encode(encoded));
    }
    return encoded;
  }

  static String? decodeIpFromQrCode(String qrCodeData, {int encodingLevel = 10}) {
    var decoder = Base64Decoder();
    try {
      var decoded = decoder.convert(qrCodeData);
      for (var i = 1; i < encodingLevel; i++) {
        decoded = decoder.convert(utf8.decode(decoded));
      }
      return decodeIp(utf8.decode(decoded));
    } catch (FormatException) {
      return null;
    }
  }

  static List<int>? _ipToInt(String ip) {
    List<int> ipAsInt = <int>[];
    for (var char in ip.split('')) {
      var digit = int.tryParse(char);
      if (digit == null) {
        print("not allowed character in ip");
        return null;
      }
      ipAsInt.add(digit);
    }
    return ipAsInt;
  }
}
