import 'dart:convert';

import 'json_format/json_format.dart';


class MatchAgeEntity {
  MatchAgeEntity({
    this.max,
    this.min,
  });

  factory MatchAgeEntity.fromJson(Map<String, dynamic> jsonRes) =>
      MatchAgeEntity(
        max: asT<String?>(jsonRes['max']),
        min: asT<String?>(jsonRes['min']),
      );

  String? max;
  String? min;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'max': max,
    'min': min,
  };

  MatchAgeEntity clone() => MatchAgeEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
