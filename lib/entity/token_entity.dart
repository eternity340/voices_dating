import 'dart:convert';

import '../service/token_service.dart';
import 'json_format/json_format.dart';



class TokenEntity {
  TokenEntity({
    this.accessToken,
    this.refreshToken,
    this.expiredIn,
    this.requestTime,
  });

  factory TokenEntity.fromJson(Map<String, dynamic> jsonRes) => TokenEntity(
    accessToken: asT<String?>(jsonRes['access_token']),
    refreshToken: asT<String?>(jsonRes['refresh_token']),
    expiredIn: asT<int?>(jsonRes['expired_in']),
    requestTime: asT<int?>(jsonRes['request_time']),
  );

  String? accessToken;
  String? refreshToken;
  int? expiredIn;
  int? requestTime;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'expired_in': expiredIn,
    'request_time':requestTime
  };

  TokenEntity clone() => TokenEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
