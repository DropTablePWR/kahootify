import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:kahootify/const.dart';
import 'package:kahootify/core/models/errors.dart';
import 'package:kahootify_server/models/category.dart';

class RemoteTriviaRepository {
  static Future<Either<ApiError, List<Category>>> getAllAvailableCategories() async {
    Uri uri;
    uri = Uri.https(kApiUrl, "api_category.php");
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      return Left(ApiError(jsonDecode(response.body)));
    }
    var data = jsonDecode(response.body)['trivia_categories'];
    return Right(
      List<Category>.from(data.map((rawCategory) {
        return Category.fromJson(rawCategory);
      }).toList()),
    );
  }
}
