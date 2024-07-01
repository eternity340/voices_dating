import 'dart:convert';

import 'json_format/json_format.dart';


class UserPhotoEntity {
  UserPhotoEntity({
    this.about,
    this.attachId,
    this.avatar,
    this.height,
    this.sort,
    this.status,
    this.url,
    this.width,
  });

  factory UserPhotoEntity.fromJson(Map<String, dynamic> jsonRes) => UserPhotoEntity(
    about: asT<Object?>(jsonRes['about']),
    attachId: asT<String?>(jsonRes['attachId']),
    avatar: asT<bool?>(jsonRes['avatar']),
    height: asT<String?>(jsonRes['height']),
    sort: asT<String?>(jsonRes['sort']),
    status: asT<String?>(jsonRes['status']),
    url: asT<String?>(jsonRes['url']),
    width: asT<String?>(jsonRes['width']),
  );

  Object? about;
  String? attachId;
  bool? avatar;
  String? height;
  String? sort;
  String? status;
  String? url;
  String? width;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'about': about,
    'attachId': attachId,
    'avatar': avatar,
    'height': height,
    'sort': sort,
    'status': status,
    'url': url,
    'width': width,
  };

  UserPhotoEntity clone() => UserPhotoEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
