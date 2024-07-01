import 'dart:convert';

import 'json_format/json_format.dart';

class CommentReplyEntity {
  CommentReplyEntity({
    this.commentId,
    this.atCommentId,
    this.commentContent,
    this.commentCreated,
    this.contentPending,
    this.membership,
    this.age,
    this.avatar,
    this.avatarThumb,
    this.blockedMe,
    this.gender,
    this.hidden,
    this.hiddenGender,
    this.member,
    this.timelineId,
    this.userId,
    this.username,
  });

  factory CommentReplyEntity.fromJson(Map<String, dynamic> jsonRes) =>
      CommentReplyEntity(
        commentId: asT<String?>(jsonRes['commentId']),
        atCommentId: asT<String?>(jsonRes['atCommentId']),
        commentContent: asT<String?>(jsonRes['commentContent']),
        commentCreated: asT<String?>(jsonRes['commentCreated']),
        contentPending: asT<String?>(jsonRes['contentPending']),
        membership: asT<String?>(jsonRes['membership']),
        age: asT<String?>(jsonRes['age']),
        avatar: asT<String?>(jsonRes['avatar']),
        avatarThumb: asT<String?>(jsonRes['avatarThumb']),
        blockedMe: asT<int?>(jsonRes['blockedMe']),
        gender: asT<String?>(jsonRes['gender']),
        hidden: asT<String?>(jsonRes['hidden']),
        hiddenGender: asT<String?>(jsonRes['hiddenGender']),
        member: asT<String?>(jsonRes['member']),
        timelineId: asT<String?>(jsonRes['timelineId']),
        userId: asT<String?>(jsonRes['userId']),
        username: asT<String?>(jsonRes['username']),
      );

  String? commentId;
  String? atCommentId;
  String? commentContent;
  String? commentCreated;
  String? contentPending;
  String? membership;
  String? age;
  String? avatar;
  String? avatarThumb;
  int? blockedMe;
  String? gender;
  String? hidden;
  String? hiddenGender;
  String? member;
  String? timelineId;
  String? userId;
  String? username;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'commentId': commentId,
    'atCommentId': atCommentId,
    'commentContent': commentContent,
    'commentCreated': commentCreated,
    'contentPending': contentPending,
    'membership': membership,
    'age': age,
    'avatar': avatar,
    'avatarThumb': avatarThumb,
    'blockedMe': blockedMe,
    'gender': gender,
    'hidden': hidden,
    'hiddenGender': hiddenGender,
    'member': member,
    'timelineId': timelineId,
    'userId': userId,
    'username': username,
  };
}
