
import '../constants/constant_data.dart';
import 'json_format/json_format.dart';

class BaseEntity<T> {
  int code = -1;
  String msg = "";
  T? data;

  BaseEntity({this.code = -1, this.msg = "", this.data});

  BaseEntity.fromJson(Map<String, dynamic> jsonMap) {
    if (jsonMap.containsKey(ConstantData.code)) {
      code = jsonMap[ConstantData.code] as int;
    }
    if (jsonMap[ConstantData.message] != null) {
      msg = jsonMap[ConstantData.message] as String;
    }
    if (jsonMap.containsKey(ConstantData.data)) {
      var jsonObj = jsonMap[ConstantData.data];
      if (jsonObj is List) {
        data = FFConvert.convert<T>(jsonObj);
      } else if (jsonObj.toString().isNotEmpty) {
        data = FFConvert.convert<T>(jsonObj);
      }
    }
  }
}
