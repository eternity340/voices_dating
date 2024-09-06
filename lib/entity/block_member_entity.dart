import 'dart:convert';
import 'json_format/json_format.dart';
import 'list_user_entity.dart'; // Import other necessary entities or utilities


class BlockMemberEntity {
  BlockMemberEntity({
    this.age,
    this.avatar,
    this.avatarHeight,
    this.avatarThumb,
    this.avatarWidth,
    this.blocked,
    this.blockedMe,
    this.body,
    this.canWink,
    this.created,
    this.cropInfo,
    this.curLocation,
    this.disability,
    this.displayCertifiedIncomeIcon,
    this.distance,
    this.ethnicity,
    this.gender,
    this.haveKids,
    this.headline,
    this.height,
    this.hidden,
    this.hiddenCurrentLocation,
    this.hiddenGender,
    this.hiddenOnline,
    this.income,
    this.lastActiveTime,
    this.lastTimeline,
    this.likeMeType,
    this.likeType,
    this.liked,
    this.likedMe,
    this.location,
    this.marital,
    this.matchedExpired,
    this.matchedExpiredTime,
    this.member,
    this.note,
    this.online,
    this.photoCnt,
    this.realChat,
    this.regDays,
    this.roomId,
    this.superLikeMeCnt,
    this.tags,
    this.timeLineStatus,
    this.userId,
    this.username,
    this.verified,
    this.verifiedIncome,
    this.verifiedIncomeType,
    this.videoCnt,
    this.videoList,
    this.winked,
    this.winkedMe,
  });

  factory BlockMemberEntity.fromJson(Map<String, dynamic> json) {
    final List<Object>? lastTimeline =
    json['lastTimeline'] is List ? <Object>[] : null;
    if (lastTimeline != null) {
      for (final dynamic item in json['lastTimeline']!) {
        if (item != null) {
          tryCatch(() {
            lastTimeline.add(asT<Object>(item)!);
          });
        }
      }
    }

    final List<Object>? tags = json['tags'] is List ? <Object>[] : null;
    if (tags != null) {
      for (final dynamic item in json['tags']!) {
        if (item != null) {
          tryCatch(() {
            tags.add(asT<Object>(item)!);
          });
        }
      }
    }

    return BlockMemberEntity(
      age: asT<String?>(json['age']),
      avatar: asT<String?>(json['avatar']),
      avatarHeight: asT<int?>(json['avatarHeight']),
      avatarThumb: asT<String?>(json['avatarThumb']),
      avatarWidth: asT<int?>(json['avatarWidth']),
      blocked: asT<int?>(json['blocked']),
      blockedMe: asT<int?>(json['blockedMe']),
      body: asT<int?>(json['body']),
      canWink: asT<int?>(json['canWink']),
      created: asT<int?>(json['created']),
      cropInfo: asT<Object?>(json['cropInfo']),
      curLocation: json['curLocation'] == null
          ? null
          : Location.fromJson(asT<Map<String, dynamic>>(json['curLocation'])!),
      disability: asT<String?>(json['disability']),
      displayCertifiedIncomeIcon: asT<String?>(json['displayCertifiedIncomeIcon']),
      distance: asT<int?>(json['distance']),
      ethnicity: asT<int?>(json['ethnicity']),
      gender: asT<String?>(json['gender']),
      haveKids: asT<int?>(json['haveKids']),
      headline: asT<String?>(json['headline']),
      height: asT<int?>(json['height']),
      hidden: asT<String?>(json['hidden']),
      hiddenCurrentLocation: asT<String?>(json['hiddenCurrentLocation']),
      hiddenGender: asT<String?>(json['hiddenGender']),
      hiddenOnline: asT<String?>(json['hiddenOnline']),
      income: asT<String?>(json['income']),
      lastActiveTime: asT<int?>(json['lastActiveTime']),
      lastTimeline: lastTimeline,
      likeMeType: asT<int?>(json['likeMeType']),
      likeType: asT<int?>(json['likeType']),
      liked: asT<int?>(json['liked']),
      likedMe: asT<int?>(json['likedMe']),
      location: json['location'] == null
          ? null
          : Location.fromJson(asT<Map<String, dynamic>>(json['location'])!),
      marital: asT<int?>(json['marital']),
      matchedExpired: asT<String?>(json['matchedExpired']),
      matchedExpiredTime: asT<int?>(json['matchedExpiredTime']),
      member: asT<String?>(json['member']),
      note: asT<String?>(json['note']),
      online: asT<String?>(json['online']),
      photoCnt: asT<String?>(json['photoCnt']),
      realChat: asT<String?>(json['realChat']),
      regDays: asT<int?>(json['regDays']),
      roomId: asT<String?>(json['roomId']),
      superLikeMeCnt: asT<int?>(json['superLikeMeCnt']),
      tags: tags,
      timeLineStatus: asT<String?>(json['timeLineStatus']),
      userId: asT<String?>(json['userId']),
      username: asT<String?>(json['username']),
      verified: asT<String?>(json['verified']),
      verifiedIncome: asT<String?>(json['verifiedIncome']),
      verifiedIncomeType: asT<String?>(json['verifiedIncomeType']),
      videoCnt: asT<int?>(json['videoCnt']),
      videoList: asT<int?>(json['videoList']),
      winked: asT<int?>(json['winked']),
      winkedMe: asT<int?>(json['winkedMe']),
    );
  }

  String? age;
  String? avatar;
  int? avatarHeight;
  String? avatarThumb;
  int? avatarWidth;
  int? blocked;
  int? blockedMe;
  int? body;
  int? canWink;
  int? created;
  Object? cropInfo;
  Location? curLocation;
  String? disability;
  String? displayCertifiedIncomeIcon;
  int? distance;
  int? ethnicity;
  String? gender;
  int? haveKids;
  String? headline;
  int? height;
  String? hidden;
  String? hiddenCurrentLocation;
  String? hiddenGender;
  String? hiddenOnline;
  String? income;
  int? lastActiveTime;
  List<Object>? lastTimeline;
  int? likeMeType;
  int? likeType;
  int? liked;
  int? likedMe;
  Location? location;
  int? marital;
  String? matchedExpired;
  int? matchedExpiredTime;
  String? member;
  String? note;
  String? online;
  String? photoCnt;
  String? realChat;
  int? regDays;
  String? roomId;
  int? superLikeMeCnt;
  List<Object>? tags;
  String? timeLineStatus;
  String? userId;
  String? username;
  String? verified;
  String? verifiedIncome;
  String? verifiedIncomeType;
  int? videoCnt;
  int? videoList;
  int? winked;
  int? winkedMe;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'age': age,
    'avatar': avatar,
    'avatarHeight': avatarHeight,
    'avatarThumb': avatarThumb,
    'avatarWidth': avatarWidth,
    'blocked': blocked,
    'blockedMe': blockedMe,
    'body': body,
    'canWink': canWink,
    'created': created,
    'cropInfo': cropInfo,
    'curLocation': curLocation,
    'disability': disability,
    'displayCertifiedIncomeIcon': displayCertifiedIncomeIcon,
    'distance': distance,
    'ethnicity': ethnicity,
    'gender': gender,
    'haveKids': haveKids,
    'headline': headline,
    'height': height,
    'hidden': hidden,
    'hiddenCurrentLocation': hiddenCurrentLocation,
    'hiddenGender': hiddenGender,
    'hiddenOnline': hiddenOnline,
    'income': income,
    'lastActiveTime': lastActiveTime,
    'lastTimeline': lastTimeline,
    'likeMeType': likeMeType,
    'likeType': likeType,
    'liked': liked,
    'likedMe': likedMe,
    'location': location,
    'marital': marital,
    'matchedExpired': matchedExpired,
    'matchedExpiredTime': matchedExpiredTime,
    'member': member,
    'note': note,
    'online': online,
    'photoCnt': photoCnt,
    'realChat': realChat,
    'regDays': regDays,
    'roomId': roomId,
    'superLikeMeCnt': superLikeMeCnt,
    'tags': tags,
    'timeLineStatus': timeLineStatus,
    'userId': userId,
    'username': username,
    'verified': verified,
    'verifiedIncome': verifiedIncome,
    'verifiedIncomeType': verifiedIncomeType,
    'videoCnt': videoCnt,
    'videoList': videoList,
    'winked': winked,
    'winkedMe': winkedMe,
  };

}
