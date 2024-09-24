import 'dart:convert';
import 'json_format/json_format.dart';

class OptionEntity {
  OptionEntity({
    this.id,
    this.label,
  });

  factory OptionEntity.fromJson(Map<String, dynamic> jsonRes) => OptionEntity(
    id: asT<String?>(jsonRes['id']),
    label: asT<String?>(jsonRes['label']),
  );

  String? id;
  String? label;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'label': label,
  };

  OptionEntity clone() => OptionEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
