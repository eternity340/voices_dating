import 'dart:convert';

import 'package:first_app/entity/json_format/json_format.dart';

class ChatStatusEntity {
  ChatStatusEntity({
    this.ret,
    this.verifiedAndMatched,
    this.chattedStatus,
  });

  factory ChatStatusEntity.fromJson(Map<String, dynamic> jsonRes) => ChatStatusEntity(
    ret: asT<int?>(jsonRes['ret']),
    verifiedAndMatched: asT<int?>(jsonRes['verifiedAndMatched']),
    chattedStatus: asT<int?>(jsonRes['chattedStatus']),
  );

  int? ret;
  int? verifiedAndMatched;
  int? chattedStatus;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'ret': ret,
    'verifiedAndMatched': verifiedAndMatched,
    'chattedStatus': chattedStatus,
  };

  ChatStatusEntity clone() => ChatStatusEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}