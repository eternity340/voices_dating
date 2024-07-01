import 'dart:convert';

import 'json_format/json_format.dart';

class NotificationEntity {
  NotificationEntity({
    this.avatar,
    this.avatarHeight,
    this.avatarId,
    this.avatarWidth,
    this.created,
    this.cropInfo,
    this.descr,
    this.gender,
    this.hidden,
    this.hiddenGender,
    this.isNew,
    this.likedMe,
    this.myRownum,
    this.notificationId,
    this.profId,
    this.timelineId,
    this.type,
    this.username,
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> jsonRes) =>
      NotificationEntity(
        avatar: asT<String?>(jsonRes['avatar']),
        avatarHeight: asT<String?>(jsonRes['avatarHeight']),
        avatarId: asT<String?>(jsonRes['avatarId']),
        avatarWidth: asT<String?>(jsonRes['avatarWidth']),
        created: asT<String?>(jsonRes['created']),
        cropInfo: asT<Object?>(jsonRes['cropInfo']),
        descr: asT<String?>(jsonRes['descr']),
        gender: asT<String?>(jsonRes['gender']),
        hidden: asT<String?>(jsonRes['hidden']),
        hiddenGender: asT<String?>(jsonRes['hiddenGender']),
        isNew: asT<String?>(jsonRes['isNew']),
        likedMe: asT<int?>(jsonRes['likedMe']),
        myRownum: asT<String?>(jsonRes['myRownum']),
        notificationId: asT<String?>(jsonRes['notificationId']),
        profId: asT<String?>(jsonRes['profId']),
        timelineId: asT<Object?>(jsonRes['timelineId']),
        type: asT<String?>(jsonRes['type']),
        username: asT<String?>(jsonRes['username']),
      );

  String? avatar;
  String? avatarHeight;
  String? avatarId;
  String? avatarWidth;
  String? created;
  Object? cropInfo;
  String? descr;
  String? gender;
  String? hidden;
  String? hiddenGender;
  String? isNew;
  int? likedMe;
  String? myRownum;
  String? notificationId;
  String? profId;
  Object? timelineId;
  String? type;
  String? username;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'avatar': avatar,
    'avatarHeight': avatarHeight,
    'avatarId': avatarId,
    'avatarWidth': avatarWidth,
    'created': created,
    'cropInfo': cropInfo,
    'descr': descr,
    'gender': gender,
    'hidden': hidden,
    'hiddenGender': hiddenGender,
    'isNew': isNew,
    'likedMe': likedMe,
    'myRownum': myRownum,
    'notificationId': notificationId,
    'profId': profId,
    'timelineId': timelineId,
    'type': type,
    'username': username,
  };

  NotificationEntity clone() => NotificationEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}