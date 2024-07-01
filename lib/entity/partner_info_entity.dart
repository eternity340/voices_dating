import 'dart:convert';

import 'json_format/json_format.dart';
import 'user_location_entity.dart';




class PartnerInfoEntity {
  PartnerInfoEntity({
    this.age,
    this.birthday,
    this.body,
    this.ethnicity,
    this.eyes,
    this.hair,
    this.height,
    this.location,
    this.partnergender,
    this.partnername,
    this.avatar,
    this.selfgender,
  });

  factory PartnerInfoEntity.fromJson(Map<String, dynamic> json) =>
      PartnerInfoEntity(
        age: asT<int?>(json['age']),
        birthday: asT<String?>(json['birthday']),
        body: asT<String?>(json['body']),
        ethnicity: asT<String?>(json['ethnicity']),
        eyes: asT<String?>(json['eyes']),
        hair: asT<String?>(json['hair']),
        height: asT<String?>(json['height']),
        location: json['location'] == null
            ? null
            : UserLocationEntity.fromJson(
            asT<Map<String, dynamic>>(json['location'])!),
        partnergender: asT<String>(json['partnerGender']),
        partnername: asT<String>(json['partnerName']),
        avatar: asT<String>(json['avatar']),
        selfgender: asT<String>(json['selfGender']),
      );

  int? age;
  String? birthday;
  String? body;
  String? ethnicity;
  String? eyes;
  String? hair;
  String? height;
  UserLocationEntity? location;
  String? partnergender;
  String? partnername;
  String? avatar;
  String? selfgender;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'age': age,
    'birthday': birthday,
    'body': body,
    'ethnicity': ethnicity,
    'eyes': eyes,
    'hair': hair,
    'height': height,
    'location': location,
    'partnerGender': partnergender,
    'partnerName': partnername,
    'avatar': avatar,
    'selfGender': selfgender,
  };
}
