import 'dart:convert';

import 'json_format/json_format.dart';


class CityEntity {
  CityEntity({
    this.cityId,
    this.cityName,
  });

  factory CityEntity.fromJson(Map<String, dynamic> jsonRes) => CityEntity(
        cityId: asT<String?>(jsonRes['cityId']),
        cityName: asT<String?>(jsonRes['cityName']),
      );

  String? cityId;
  String? cityName;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'cityId': cityId,
        'cityName': cityName,
      };

  CityEntity clone() => CityEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
