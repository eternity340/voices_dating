import 'dart:convert';

import 'json_format/json_format.dart';


class RetEntity {
  RetEntity({
    required this.ret,
  });

  factory RetEntity.fromJson(Map<String, dynamic> jsonRes) => RetEntity(
    ret: asT<bool>(jsonRes['ret'], false) ?? false,
  );

  bool ret;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'ret': ret,
  };

  RetEntity clone() => RetEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
