import 'dart:convert';

import 'json_format/json_format.dart';


class LocationEntity {
  LocationEntity({
    this.city,
    this.cityId,
    this.countAbbr,
    this.countCode,
    this.country,
    this.countryId,
    this.curAddress,
    this.state,
    this.stateAbbr,
    this.stateId,
  });

  factory LocationEntity.fromJson(Map<String, dynamic> jsonRes) =>
      LocationEntity(
        city: asT<String?>(jsonRes['city'] ?? jsonRes['curCity']),
        cityId: asT<String?>(jsonRes['cityId'] ?? jsonRes['curCityId']),
        country: asT<String?>(jsonRes['country'] ?? jsonRes['curCountry']),
        countAbbr: asT<String?>(jsonRes['countAbbr']),
        countCode: asT<String?>(jsonRes['countCode']),
        countryId:
        asT<String?>(jsonRes['countryId'] ?? jsonRes['curCountryId']),
        curAddress: asT<String?>(jsonRes['curAddress']),
        stateAbbr: asT<String?>(jsonRes['stateAbbr']),
        state: asT<String?>(jsonRes['state'] ?? jsonRes['curState']),
        stateId: asT<String?>(jsonRes['stateId'] ?? jsonRes['curStateId']),
      );

  String? city;
  String? cityId;
  String? countAbbr;
  String? countCode;
  String? country;
  String? countryId;
  String? curAddress;
  String? stateAbbr;
  String? state;
  String? stateId;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'city': city,
    'cityId': cityId,
    'countAbbr': countAbbr,
    'countCode': countCode,
    'country': country,
    'countryId': countryId,
    'curAddress': curAddress,
    'stateAbbr': stateAbbr,
    'state': state,
    'stateId': stateId,
  };

  LocationEntity clone() => LocationEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);

  String toAddress() {
    return [city, state, country]
        .where((element) => element != null && element.isNotEmpty)
        .join(", ");
  }
}

class CurrentLocation {
  CurrentLocation({
    this.countAbbr,
    this.countCode,
    this.curAddress,
    this.curCity,
    this.curCityId,
    this.curCountry,
    this.curCountryId,
    this.curState,
    this.curStateId,
    this.stateAbbr,
  });

  factory CurrentLocation.fromJson(Map<String, dynamic> json) =>

      CurrentLocation(
        countAbbr: asT<String?>(json['countAbbr']),
        countCode: asT<String?>(json['countCode']),
        curAddress: asT<String?>(json['curAddress']),
        curCity: asT<String?>(json['curCity'] ?? json['city']),
        curCityId: asT<String?>(json['curCityId'] ?? json['cityId']),
        curCountry: asT<String?>(json['curCountry'] ?? json['country']),
        curCountryId: asT<String?>(json['curCountryId'] ?? json['countryId']),
        curState: asT<String?>(json['curState'] ?? json['state']),
        curStateId: asT<String?>(json['curStateId'] ?? json['stateId']),
        stateAbbr: asT<String?>(json['stateAbbr']),
      );

  String? countAbbr;
  String? countCode;
  String? curAddress;
  String? curCity;
  String? curCityId;
  String? curCountry;
  String? curCountryId;
  String? curState;
  String? curStateId;
  String? stateAbbr;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'countAbbr': countAbbr,
    'countCode': countCode,
    'curAddress': curAddress,
    'curCity': curCity,
    'curCityId': curCityId,
    'curCountry': curCountry,
    'curCountryId': curCountryId,
    'curState': curState,
    'curStateId': curStateId,
    'stateAbbr': stateAbbr,
  };
}
