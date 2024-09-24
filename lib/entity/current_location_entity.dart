import 'dart:convert';

import 'json_format/json_format.dart';

class CurrentLocationEntity {
  CurrentLocationEntity({
    this.citId,
    this.citName,
    this.couCode,
    this.couId,
    this.couName,
    this.countCode,
    this.latitude,
    this.longitude,
    this.sttAbbr,
    this.sttId,
    this.sttName,
  });

  factory CurrentLocationEntity.fromJson(Map<String, dynamic> json) => CurrentLocationEntity(
    citId: asT<String?>(json['citId']),
    citName: asT<String?>(json['citName']),
    couCode: asT<String?>(json['couCode']),
    couId: asT<String?>(json['couId']),
    couName: asT<String?>(json['couName']),
    countCode: asT<String?>(json['countCode']),
    latitude: asT<String?>(json['latitude']),
    longitude: asT<String?>(json['longitude']),
    sttAbbr: asT<String?>(json['sttAbbr']),
    sttId: asT<String?>(json['sttId']),
    sttName: asT<String?>(json['sttName']),
  );

  String? citId;
  String? citName;
  String? couCode;
  String? couId;
  String? couName;
  String? countCode;
  String? latitude;
  String? longitude;
  String? sttAbbr;
  String? sttId;
  String? sttName;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'citId': citId,
    'citName': citName,
    'couCode': couCode,
    'couId': couId,
    'couName': couName,
    'countCode': countCode,
    'latitude': latitude,
    'longitude': longitude,
    'sttAbbr': sttAbbr,
    'sttId': sttId,
    'sttName': sttName,
  };

  CurrentLocationEntity clone() => CurrentLocationEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);

  String toAddress() {
    return [citName, sttName, couName]
        .where((element) => element != null && element.isNotEmpty)
        .join(", ");
  }
}
