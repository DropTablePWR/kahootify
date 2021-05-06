abstract class Data {
  late DataType dataType;

  Data(this.dataType);

  Data.fromJson(Map<String, dynamic> json) {
    var type = json['type'];
    if (type == null)
      dataType = DataType.Unknown;
    else
      dataType = type;
  }

  Map<String, dynamic> toJson() {
    return {'type': dataType.toString()};
  }
}

enum DataType { ServerInfo, UserInfo, Unknown, Error }
