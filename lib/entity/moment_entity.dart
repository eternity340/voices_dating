import 'dart:convert';

import 'attachment_entity.dart';
import 'comment_entity.dart';
import 'json_format/json_format.dart';
import 'user_data_entity.dart';

class MomentEntity {
  MomentEntity({
    this.age,
    this.attachments,
    this.avatar,
    this.avatarThumb,
    this.blockedMe,
    this.city,
    this.comments,
    this.commentsCount,
    this.country,
    this.countCode,
    this.ethnicity,
    this.gender,
    this.hidden,
    this.hiddenGender,
    this.liked,
    this.likedCnt,
    this.likers,
    this.member,
    this.state,
    this.timelineDate,
    this.timelineDescr,
    this.timelineId,
    this.timelineStatus,
    this.timelineType,
    this.timelineTypeDescr,
    this.userId,
    this.username,
    this.tag,
  });

  factory MomentEntity.fromJson(Map<String, dynamic> jsonRes) {
    final List<AttachmentEntity>? attachments =
    jsonRes['attachments'] is List ? <AttachmentEntity>[] : null;
    if (attachments != null) {
      for (final dynamic item in jsonRes['attachments']!) {
        if (item != null) {
          tryCatch(() {
            attachments.add(
                AttachmentEntity.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<CommentEntity>? comments =
    jsonRes['comments'] is List ? <CommentEntity>[] : null;
    if (comments != null) {
      for (final dynamic item in jsonRes['comments']!) {
        if (item != null) {
          tryCatch(() {
            comments
                .add(CommentEntity.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<UserDataEntity>? likers =
    jsonRes['likers'] is List ? <UserDataEntity>[] : null;
    if (likers != null) {
      for (final dynamic item in jsonRes['likers']!) {
        if (item != null) {
          tryCatch(() {
            likers.add(UserDataEntity.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return MomentEntity(
      age: asT<String?>(jsonRes['age']),
      attachments: attachments,
      avatar: asT<String?>(jsonRes['avatar']),
      avatarThumb: asT<String?>(jsonRes['avatarThumb']),
      blockedMe: asT<int?>(jsonRes['blockedMe']),
      city: asT<String?>(jsonRes['city']),
      comments: comments,
      commentsCount: asT<String?>(jsonRes['commentsCount']),
      country: asT<String?>(jsonRes['country']),
      countCode: asT<String?>(jsonRes['countCode']),
      ethnicity: asT<String?>(jsonRes['ethnicity']),
      gender: asT<String?>(jsonRes['gender']),
      hidden: asT<String?>(jsonRes['hidden']),
      hiddenGender: asT<String?>(jsonRes['hiddenGender']),
      liked: asT<int?>(jsonRes['liked']),
      likedCnt: asT<String?>(jsonRes['likedCnt']),
      likers: likers,
      member: asT<String?>(jsonRes['member']),
      state: asT<String?>(jsonRes['state']),
      timelineDate: asT<int?>(jsonRes['timelineDate']),
      timelineDescr: asT<String?>(jsonRes['timelineDescr']),
      timelineId: asT<String?>(jsonRes['timelineId']),
      timelineStatus: asT<String?>(jsonRes['timelineStatus']),
      timelineType: asT<String?>(jsonRes['timelineType']),
      timelineTypeDescr: asT<String?>(jsonRes['timelineTypeDescr']),
      userId: asT<String?>(jsonRes['userId']),
      username: asT<String?>(jsonRes['username']),
      tag: asT<String?>(jsonRes['tag']),
    );
  }

  String? age;
  List<AttachmentEntity>? attachments;
  String? avatar;
  String? avatarThumb;
  int? blockedMe;
  String? city;
  List<CommentEntity>? comments;
  String? commentsCount;
  String? country;
  String? countCode;
  String? ethnicity;
  String? gender;
  String? hidden;
  String? hiddenGender;
  int? liked;
  String? likedCnt;
  List<UserDataEntity>? likers;
  String? member;
  String? state;
  int? timelineDate;
  String? timelineDescr;
  String? timelineId;
  String? timelineStatus;
  String? timelineType;
  String? timelineTypeDescr;
  String? userId;
  String? username;
  String? tag;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'age': age,
    'attachments': attachments,
    'avatar': avatar,
    'avatarThumb': avatarThumb,
    'blockedMe': blockedMe,
    'city': city,
    'comments': comments,
    'commentsCount': commentsCount,
    'country': country,
    'countCode': countCode,
    'ethnicity': ethnicity,
    'gender': gender,
    'hidden': hidden,
    'hiddenGender': hiddenGender,
    'liked': liked,
    'likedCnt': likedCnt,
    'likers': likers,
    'member': member,
    'state': state,
    'timelineDate': timelineDate,
    'timelineDescr': timelineDescr,
    'timelineId': timelineId,
    'timelineStatus': timelineStatus,
    'timelineType': timelineType,
    'timelineTypeDescr': timelineTypeDescr,
    'userId': userId,
    'username': username,
    'tag': tag,
  };

  MomentEntity clone() => MomentEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);

  @override
  bool operator ==(Object other) =>
      other is MomentEntity && timelineId == other.timelineId;

  @override
  int get hashCode => timelineId.hashCode;

}
