
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

/*
import 'dart:convert';
import 'package:first_app/net/api_constants.dart';
import '../constants/constant_data.dart';
import '../net/api_constants.dart';
import 'json_format/json_format.dart';

class BaseEntity<T> {
  final int code;
  final String msg;
  final T? data;

  BaseEntity({this.code = -1, this.msg = "", this.data});

  factory BaseEntity.fromJson(Map<String, dynamic> jsonMap) {
    final int code = jsonMap[ConstantData.code] as int? ?? -1;
    final String msg = jsonMap[ConstantData.message] as String? ?? "";
    T? data;

    if (jsonMap.containsKey(ConstantData.data)) {
      var jsonObj = jsonMap[ConstantData.data];

      if (jsonObj != null && jsonObj.toString().isNotEmpty) {
        try {
          if (appIsDebug) {
            data = _convertData<T>(jsonObj);
          } else {
            var decodedData = ApiConstants.instance.decodeBase64(jsonObj);
            var jsonData = json.decode(decodedData);
            data = _convertData<T>(jsonData);
          }
        } catch (e) {
          print('Error parsing data: $e');
        }
      }
    }

    return BaseEntity(code: code, msg: msg, data: data);
  }

  static T? _convertData<T>(dynamic jsonObj) {
    if (jsonObj is List) {
      return FFConvert.convert<T>(jsonObj);
    } else if (jsonObj.toString().isNotEmpty) {
      return FFConvert.convert<T>(jsonObj);
    }
    return null;
  }

  int get statusCode => code;
  T? get statusData => data;
  String get statusMessage => msg;

}
*/

