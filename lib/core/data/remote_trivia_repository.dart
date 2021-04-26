import 'package:http/http.dart' as http;
import 'package:kahootify/const.dart';
import 'package:kahootify/core/models/api/category.dart';

class RemoteTriviaRepository {
  static Future<List<Category>> getAllAvailableCategories() async {
    Uri uri;
    uri = Uri.https(kApiUrl, "api_category.php");
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final http.Response response = await http.get(uri, headers: headers);
    return []; //TODO parse response
  }
}
