import 'package:enum_to_string/enum_to_string.dart';

abstract class Data {
  late DataType dataType;

  Data(this.dataType);

  Data.fromJson(Map<String, dynamic> json) {
    var type = EnumToString.fromString(DataType.values, json['type']);
    if (type == null)
      dataType = DataType.Unknown;
    else
      dataType = type;
  }

  Map<String, dynamic> toJson() {
    return {'type': EnumToString.convertToString(dataType)};
  }
}

enum DataType { ServerInfo, UserInfo, Unknown, Error }
