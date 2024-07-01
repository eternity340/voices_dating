import 'dart:convert';

import 'json_format/json_format.dart';

class AttachResultEntity {
  AttachResultEntity({
    this.attachId,
    this.url,
  });

  factory AttachResultEntity.fromJson(Map<String, dynamic> jsonRes) =>
      AttachResultEntity(
        attachId: asT<String?>(jsonRes['attachId']),
        url: asT<String?>(jsonRes['url']),
      );

  String? attachId;
  String? url;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'attachId': attachId,
    'url': url,
  };

  AttachResultEntity clone() => AttachResultEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}