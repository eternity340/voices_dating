import 'dart:convert';

import 'comment_reply_entity.dart';
import 'json_format/json_format.dart';




class CommentEntity {
  CommentEntity({
    this.age,
    this.atCommentId,
    this.avatar,
    this.avatarThumb,
    this.blockedMe,
    this.commentContent,
    this.commentCreated,
    this.commentId,
    this.commentLiked,
    this.commentLikes,
    this.gender,
    this.hidden,
    this.hiddenGender,
    this.member,
    this.timelineId,
    this.userId,
    this.username,
    this.replyList,
  });

  factory CommentEntity.fromJson(Map<String, dynamic> jsonRes) {

    final List<CommentReplyEntity>? replies =
    jsonRes['replies'] is List ? <CommentReplyEntity>[] : null;
    if (replies != null) {
      for (final dynamic item in jsonRes['replies']!) {
        if (item != null) {
          tryCatch(() {
            replies
                .add(CommentReplyEntity.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    return CommentEntity(
      age: asT<String?>(jsonRes['age']),
      atCommentId: asT<String?>(jsonRes['atCommentId']),
      avatar: asT<String?>(jsonRes['avatar']),
      avatarThumb: asT<String?>(jsonRes['avatarThumb']),
      blockedMe: asT<int?>(jsonRes['blockedMe']),
      commentContent: asT<String?>(jsonRes['commentContent']),
      commentCreated: asT<int?>(jsonRes['commentCreated']),
      commentId: asT<String?>(jsonRes['commentId']),
      commentLiked: asT<int?>(jsonRes['commentLiked']),
      commentLikes: asT<int?>(jsonRes['commentLikes']),
      gender: asT<String?>(jsonRes['gender']),
      hidden: asT<String?>(jsonRes['hidden']),
      hiddenGender: asT<String?>(jsonRes['hiddenGender']),
      member: asT<String?>(jsonRes['member']),
      timelineId: asT<String?>(jsonRes['timelineId']),
      userId: asT<String?>(jsonRes['userId']),
      username: asT<String?>(jsonRes['username']),
      replyList: replies,
    );
  }

  String? age;
  String? atCommentId;
  String? avatar;
  String? avatarThumb;
  int? blockedMe;
  String? commentContent;
  int? commentCreated;
  String? commentId;
  int?commentLiked;
  int? commentLikes;
  String? gender;
  String? hidden;
  String? hiddenGender;
  String? member;
  String? timelineId;
  String? userId;
  String? username;
  List<CommentReplyEntity>? replyList;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'age': age,
    'atCommentId': atCommentId,
    'avatar': avatar,
    'avatarThumb': avatarThumb,
    'blockedMe': blockedMe,
    'commentContent': commentContent,
    'commentCreated': commentCreated,
    'commentId': commentId,
    'commentLiked':commentLiked,
    'commentLikes':commentLikes,
    'gender': gender,
    'hidden': hidden,
    'hiddenGender': hiddenGender,
    'member': member,
    'timelineId': timelineId,
    'userId': userId,
    'username': username,
    'replies': replyList,
  };

  CommentEntity clone() => CommentEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
