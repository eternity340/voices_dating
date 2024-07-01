// import 'dart:convert';
//
// import 'json_format/json_format.dart';
//
// class MomentCommentEntity {
//   MomentCommentEntity({
//     this.age,
//     this.atCommentId,
//     this.avatar,
//     this.avatarThumb,
//     this.blockedMe,
//     this.commentContent,
//     this.commentCreated,
//     this.commentId,
//     this.gender,
//     this.hidden,
//     this.hiddenGender,
//     this.member,
//     this.timelineId,
//     this.userId,
//     this.username,
//   });
//
//   factory MomentCommentEntity.fromJson(Map<String, dynamic> jsonRes) => MomentCommentEntity(
//     age: asT<String?>(jsonRes['age']),
//     atCommentId: asT<String?>(jsonRes['atCommentId']),
//     avatar: asT<String?>(jsonRes['avatar']),
//     avatarThumb: asT<String?>(jsonRes['avatarThumb']),
//     blockedMe: asT<int?>(jsonRes['blockedMe']),
//     commentContent: asT<String?>(jsonRes['commentContent']),
//     commentCreated: asT<int?>(jsonRes['commentCreated']),
//     commentId: asT<String?>(jsonRes['commentId']),
//     gender: asT<String?>(jsonRes['gender']),
//     hidden: asT<String?>(jsonRes['hidden']),
//     hiddenGender: asT<String?>(jsonRes['hiddenGender']),
//     member: asT<String?>(jsonRes['member']),
//     timelineId: asT<String?>(jsonRes['timelineId']),
//     userId: asT<String?>(jsonRes['userId']),
//     username: asT<String?>(jsonRes['username']),
//   );
//
//   String? age;
//   String? atCommentId;
//   String? avatar;
//   String? avatarThumb;
//   int? blockedMe;
//   String? commentContent;
//   int? commentCreated;
//   String? commentId;
//   String? gender;
//   String? hidden;
//   String? hiddenGender;
//   String? member;
//   String? timelineId;
//   String? userId;
//   String? username;
//
//   @override
//   String toString() {
//     return jsonEncode(this);
//   }
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//     'age': age,
//     'atCommentId': atCommentId,
//     'avatar': avatar,
//     'avatarThumb': avatarThumb,
//     'blockedMe': blockedMe,
//     'commentContent': commentContent,
//     'commentCreated': commentCreated,
//     'commentId': commentId,
//     'gender': gender,
//     'hidden': hidden,
//     'hiddenGender': hiddenGender,
//     'member': member,
//     'timelineId': timelineId,
//     'userId': userId,
//     'username': username,
//   };
//
//   MomentCommentEntity clone() => MomentCommentEntity.fromJson(
//       asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
// }