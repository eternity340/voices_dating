import 'dart:convert';

import 'json_format/json_format.dart';



class TokenEntity {
  TokenEntity({
    this.accessToken,
    this.refreshToken,
    this.expriedIn,
    this.requestTime,
  });

  factory TokenEntity.fromJson(Map<String, dynamic> jsonRes) => TokenEntity(
    accessToken: asT<String?>(jsonRes['access_token']),
    refreshToken: asT<String?>(jsonRes['refresh_token']),
    expriedIn: asT<int?>(jsonRes['expried_in']),
    requestTime: asT<int?>(jsonRes['request_time']),
  );

  String? accessToken;
  String? refreshToken;
  int? expriedIn;
  int? requestTime;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'expried_in': expriedIn,
    'request_time':requestTime
  };

  TokenEntity clone() => TokenEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
