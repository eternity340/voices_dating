import 'dart:convert';
import 'json_format/json_format.dart';

class WinkEntity {
  WinkEntity({
    this.id,
    this.descr,
  });

  factory WinkEntity.fromJson(Map<String, dynamic> jsonRes) => WinkEntity(
    id: asT<String?>(jsonRes['id']),
    descr: asT<String?>(jsonRes['descr']),
  );

  String? id;
  String? descr;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'descr': descr,
  };

  WinkEntity clone() => WinkEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
