import 'dart:convert';

import 'json_format/json_format.dart';


class ProfileCommentEntity {
  ProfileCommentEntity({
    this.age,
    this.avatar,
    this.blocked,
    this.blockedme,
    this.commentid,
    this.commentstatus,
    this.created,
    this.disability,
    this.gender,
    this.hidden,
    this.hiddengender,
    this.likedme,
    this.member,
    this.membership,
    this.photocnt,
    this.text,
    this.userid,
    this.username,
    this.verified,
  });

  factory ProfileCommentEntity.fromJson(Map<String, dynamic> json) =>  ProfileCommentEntity(
    age: asT<String?>(json['age']),
    avatar: asT<String?>(json['avatar']),
    blocked: asT<int?>(json['blocked']),
    blockedme: asT<int?>(json['blockedMe']),
    commentid: asT<String?>(json['commentId']),
    commentstatus: asT<String?>(json['commentStatus']),
    created: asT<int?>(json['created']),
    disability: asT<String?>(json['disability']),
    gender: asT<String?>(json['gender']),
    hidden: asT<String?>(json['hidden']),
    hiddengender: asT<String?>(json['hiddenGender']),
    likedme: asT<String?>(json['likedMe']),
    member: asT<String?>(json['member']),
    membership: asT<String?>(json['membership']),
    photocnt: asT<String?>(json['photoCnt']),
    text: asT<String?>(json['text']),
    userid: asT<String?>(json['userId']),
    username: asT<String?>(json['username']),
    verified: asT<String?>(json['verified']),
  );

  String? age;
  String? avatar;
  int? blocked;
  int? blockedme;
  String? commentid;
  String? commentstatus;
  int? created;
  String? disability;
  String? gender;
  String? hidden;
  String? hiddengender;
  String? likedme;
  String? member;
  String? membership;
  String? photocnt;
  String? text;
  String? userid;
  String? username;
  String? verified;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'age': age,
    'avatar': avatar,
    'blocked': blocked,
    'blockedMe': blockedme,
    'commentId': commentid,
    'commentStatus': commentstatus,
    'created': created,
    'disability': disability,
    'gender': gender,
    'hidden': hidden,
    'hiddenGender': hiddengender,
    'likedMe': likedme,
    'member': member,
    'membership': membership,
    'photoCnt': photocnt,
    'text': text,
    'userId': userid,
    'username': username,
    'verified': verified,
  };
}
