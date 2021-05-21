import 'package:kahootify_server/data/remote_trivia_repository.dart';
import 'package:kahootify_server/models/category.dart';
import 'package:kahootify_server/utils/code_converter.dart';

main() async {
  var code = CodeConverter.encodeIp("001.162");
  print("CODE: $code");
  if (code == null) return;
  var ip = CodeConverter.decodeIpFromQrCode(code);
  print("IP: $ip");
  var data = await RemoteTriviaRepository.getTrivia(10, Category(id: 10, name: "test"));
  data.fold((l) => print(l.reason), (r) => print(r));
}
