import 'dart:convert';
import 'json_format/json_format.dart';

class TagEntity {
  TagEntity({
    this.tagId,
    this.tagName,
  });

  factory TagEntity.fromJson(Map<String, dynamic> jsonRes) => TagEntity(
    tagId: asT<String?>(jsonRes['tagId']),
    tagName: asT<String?>(jsonRes['tagName']),
  );

  String? tagId;
  String? tagName;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'tagId': tagId,
    'tagName': tagName,
  };

  TagEntity clone() => TagEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
