import 'package:kahootify_server/models/data.dart';

class Error extends Data {
  String message;

  Error(this.message) : super(DataType.Error);

  @override
  Map<String, dynamic> toJson() {
    var result = super.toJson();
    result['message'] = message;
    return result;
  }

  Error.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        super.fromJson(json);
}
