import 'dart:convert';

import 'json_format/json_format.dart';


class UserLocationEntity {
  UserLocationEntity({
    this.city,
    this.cityId,
    this.country,
    this.countryId,
    this.curAddress,
    this.state,
    this.stateId,
  });

  factory UserLocationEntity.fromJson(Map<String, dynamic> jsonRes) =>
      UserLocationEntity(
        city: asT<String?>(jsonRes['city']),
        cityId: asT<String?>(jsonRes['cityId']),
        country: asT<String?>(jsonRes['country']),
        countryId: asT<String?>(jsonRes['countryId']),
        curAddress: asT<String?>(jsonRes['curAddress']),
        state: asT<String?>(jsonRes['state']),
        stateId: asT<String?>(jsonRes['stateId']),
      );

  String? city;
  String? cityId;
  String? country;
  String? countryId;
  String? curAddress;
  String? state;
  String? stateId;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'city': city,
    'cityId': cityId,
    'country': country,
    'countryId': countryId,
    'curAddress': curAddress,
    'state': state,
    'stateId': stateId,
  };

  UserLocationEntity clone() => UserLocationEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);

  String toAddress() {
    return [city, state, country]
        .where((element) => element != null && element.isNotEmpty)
        .join(", ");
  }
}
