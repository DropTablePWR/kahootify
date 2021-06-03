import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:kahootify_server/const.dart';
import 'package:kahootify_server/models/category.dart';
import 'package:kahootify_server/models/errors.dart';
import 'package:kahootify_server/models/question.dart';

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

  static Future<Either<ApiError, List<Question>>> getTrivia(int numberOfQuestions, Category category) async {
    Uri uri;
    final Map<String, String> params = {'amount': numberOfQuestions.toString(), 'category': category.id.toString(), 'type': 'multiple', 'encode': 'url3986'};

    uri = Uri.https(kApiUrl, "api.php", params);
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      return Left(ApiError(jsonDecode(response.body)));
    }
    var responseBody = Uri.decodeComponent(response.body.replaceAll(RegExp(r'%22'), '%5C%22'));
    var data = jsonDecode(responseBody)['results'];
    return Right(
      List<Question>.from(data.map((rawQuestion) {
        return Question.fromJson(rawQuestion);
      }).toList()),
    );
  }
}
