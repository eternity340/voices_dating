import 'dart:convert';


import 'json_format/json_format.dart';
import 'list_user_entity.dart';
import '../utils/string_extension.dart';


class ChattedUserEntity {
  ChattedUserEntity({
    this.age,
    this.avatar,
    this.backgroundinvites,
    this.blockedme,
    this.body,
    this.canaccessmyprivate,
    this.canwink,
    this.chatbubble,
    this.created,
    this.curlocation,
    this.disability,
    this.distance,
    this.ethnicity,
    this.gender,
    this.havekids,
    this.headline,
    this.height,
    this.hidden,
    this.hiddencurrentlocation,
    this.hiddengender,
    this.hiddenonline,
    this.income,
    this.isstaff,
    this.lastactivetime,
    this.lastmessage,
    this.lastmessagesenderid,
    this.lasttimeline,
    this.likemetype,
    this.liketype,
    this.liked,
    this.likedMe,
    this.location,
    this.marital,
    this.matchedexpired,
    this.matchedexpiredtime,
    this.member,
    this.messageType,
    this.newNumber,
    this.online,
    this.partnerinfo,
    this.perfectdate,
    this.photocnt,
    this.profilerank,
    this.realChat,
    this.regdays,
    this.roomid,
    this.sentMessageStatus,
    this.sentMessageToUserStatus,
    this.status,
    this.superlikemecnt,
    this.tags,
    this.timelinestatus,
    this.toptime,
    this.userId,
    this.username,
    this.verified,
    this.verifiedincome,
    this.videocnt,
    this.videolist,
    this.winked,
    this.winkedme,
    this.wishswitch,
    this.canChat,
  });

  factory ChattedUserEntity.fromJson(Map<String, dynamic> json) {
    final List<Object>? lasttimeline =
    json['lastTimeline'] is List ? <Object>[] : null;
    if (lasttimeline != null) {
      for (final dynamic item in json['lastTimeline']!) {
        if (item != null) {
          tryCatch(() {
            lasttimeline.add(asT<Object>(item)!);
          });
        }
      }
    }

    final List<Object>? partnerinfo =
    json['partnerInfo'] is List ? <Object>[] : null;
    if (partnerinfo != null) {
      for (final dynamic item in json['partnerInfo']!) {
        if (item != null) {
          tryCatch(() {
            partnerinfo.add(asT<Object>(item)!);
          });
        }
      }
    }

    final List<Object>? perfectdate =
    json['perfectDate'] is List ? <Object>[] : null;
    if (perfectdate != null) {
      for (final dynamic item in json['perfectDate']!) {
        if (item != null) {
          tryCatch(() {
            perfectdate.add(asT<Object>(item)!);
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
    return ChattedUserEntity(
      age: asT<String?>(json['age']),
      avatar: asT<String?>(json['avatar']),
      backgroundinvites: asT<Object?>(json['backgroundInvites']),
      blockedme: asT<int?>(json['blockedMe']),
      body: asT<String?>(json['body']),
      canaccessmyprivate: asT<int?>(json['canAccessMyPrivate']),
      canwink: asT<int?>(json['canWink']),
      chatbubble: json['chatBubble'] == null
          ? null
          : Chatbubble.fromJson(asT<Map<String, dynamic>>(json['chatBubble'])!),
      created: asT<int?>(json['created']),
      curlocation: json['curLocation'] == null
          ? null
          : CurrentLocation.fromJson(
          asT<Map<String, dynamic>>(json['curLocation'])!),
      disability: asT<String?>(json['disability']),
      distance: asT<int?>(json['distance']),
      ethnicity: asT<int?>(json['ethnicity']),
      gender: asT<String?>(json['gender']),
      havekids: asT<String?>(json['haveKids']),
      headline: asT<String?>(json['headline']),
      height: asT<String?>(json['height']),
      hidden: asT<String?>(json['hidden']),
      hiddencurrentlocation: asT<int?>(json['hiddenCurrentLocation']),
      hiddengender: asT<String?>(json['hiddenGender']),
      hiddenonline: asT<String?>(json['hiddenOnline']),
      income: asT<String?>(json['income']),
      isstaff: asT<String?>(json['isStaff']),
      lastactivetime: asT<int?>(json['lastActiveTime']),
      lastmessage: asT<String?>(json['lastMessage']),
      lastmessagesenderid: asT<String?>(json['lastMessageSenderId']),
      lasttimeline: lasttimeline,
      likemetype: asT<int?>(json['likeMeType']),
      liketype: asT<int?>(json['likeType']),
      liked: asT<int?>(json['liked']),
      likedMe: asT<int?>(json['likedMe']),
      location: json['location'] == null
          ? null
          : Location.fromJson(asT<Map<String, dynamic>>(json['location'])!),
      marital: asT<String?>(json['marital']),
      matchedexpired: asT<int?>(json['matchedExpired']),
      matchedexpiredtime: asT<int?>(json['matchedExpiredTime']),
      member: asT<String?>(json['member']),
      messageType: asT<String?>(json['messageType']),
      newNumber: asT<String?>(json['newNumber'], null) ??
          asT<String?>(json['newMessageCnt']),
      online: asT<String?>(json['online']),
      partnerinfo: partnerinfo,
      perfectdate: perfectdate,
      photocnt: asT<int?>(json['photoCnt']),
      profilerank: asT<String?>(json['profileRank']),
      realChat: asT<int?>(json['realChat']),
      regdays: asT<int?>(json['regDays']),
      roomid: asT<String?>(json['roomId']),
      sentMessageStatus: asT<String?>(json['sentMessageStatus']),
      sentMessageToUserStatus: asT<String?>(json['sentMessageToUserStatus']),
      status: asT<String?>(json['status']),
      superlikemecnt: asT<int?>(json['superLikeMeCnt']),
      tags: tags,
      timelinestatus: asT<String?>(json['timeLineStatus']),
      toptime: asT<String?>(json['topTime']),
      userId: asT<String?>(json['userId']),
      username: asT<String?>(json['username']).firstUpperCase,
      verified: asT<String?>(json['verified']),
      verifiedincome: asT<String?>(json['verifiedIncome']),
      videocnt: asT<int?>(json['videoCnt']),
      videolist: asT<int?>(json['videoList']),
      winked: asT<int?>(json['winked']),
      winkedme: asT<int?>(json['winkedMe']),
      wishswitch: asT<int?>(json['wishSwitch']),
    );
  }

  String? age;
  String? avatar;
  Object? backgroundinvites;
  int? blockedme;
  String? body;
  ///1:approve/shared, 2:requested,3:rejected
  int? canaccessmyprivate;
  int? canwink;
  Chatbubble? chatbubble;
  int? created;
  CurrentLocation? curlocation;
  String? disability;
  int? distance;
  int? ethnicity;
  String? gender;
  String? havekids;
  String? headline;
  String? height;
  String? hidden;
  int? hiddencurrentlocation;
  String? hiddengender;
  String? hiddenonline;
  String? income;
  String? isstaff;
  int? lastactivetime;
  String? lastmessage;
  String? lastmessagesenderid;
  List<Object>? lasttimeline;
  int? likemetype;
  int? liketype;
  int? liked;
  int? likedMe;
  Location? location;
  String? marital;
  int? matchedexpired;
  int? matchedexpiredtime;
  String? member;
  String? messageType;
  String? newNumber;
  String? online;
  List<Object>? partnerinfo;
  List<Object>? perfectdate;
  int? photocnt;
  String? profilerank;
  int? realChat;
  int? regdays;
  String? roomid;
  String? sentMessageStatus;
  String? sentMessageToUserStatus;
  ///用户状态 0: pending, 1: approved, 2: refused, 3: blocked, 4: removed, 5: on hold'
  String? status;
  int? superlikemecnt;
  List<Object>? tags;
  String? timelinestatus;
  String? toptime;
  String? userId;
  String? username;
  String? verified;
  String? verifiedincome;
  int? videocnt;
  int? videolist;
  int? winked;
  int? winkedme;
  int? wishswitch;
  int? canChat;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'age': age,
    'avatar': avatar,
    'backgroundInvites': backgroundinvites,
    'blockedMe': blockedme,
    'body': body,
    'canAccessMyPrivate': canaccessmyprivate,
    'canWink': canwink,
    'chatBubble': chatbubble,
    'created': created,
    'curLocation': curlocation,
    'disability': disability,
    'distance': distance,
    'ethnicity': ethnicity,
    'gender': gender,
    'haveKids': havekids,
    'headline': headline,
    'height': height,
    'hidden': hidden,
    'hiddenCurrentLocation': hiddencurrentlocation,
    'hiddenGender': hiddengender,
    'hiddenOnline': hiddenonline,
    'income': income,
    'isStaff': isstaff,
    'lastActiveTime': lastactivetime,
    'lastMessage': lastmessage,
    'lastMessageSenderId': lastmessagesenderid,
    'lastTimeline': lasttimeline,
    'likeMeType': likemetype,
    'likeType': liketype,
    'liked': liked,
    'likedMe': likedMe,
    'location': location,
    'marital': marital,
    'matchedExpired': matchedexpired,
    'matchedExpiredTime': matchedexpiredtime,
    'member': member,
    'messageType': messageType,
    'newNumber': newNumber,
    'online': online,
    'partnerInfo': partnerinfo,
    'perfectDate': perfectdate,
    'photoCnt': photocnt,
    'profileRank': profilerank,
    'realChat': realChat,
    'regDays': regdays,
    'roomId': roomid,
    'sentMessageStatus': sentMessageStatus,
    'sentMessageToUserStatus': sentMessageToUserStatus,
    'status': status,
    'superLikeMeCnt': superlikemecnt,
    'tags': tags,
    'timeLineStatus': timelinestatus,
    'topTime': toptime,
    'userId': userId,
    'username': username,
    'verified': verified,
    'verifiedIncome': verifiedincome,
    'videoCnt': videocnt,
    'videoList': videolist,
    'winked': winked,
    'winkedMe': winkedme,
    'wishSwitch': wishswitch,
  };

  bool isSupport() {
    return username?.toLowerCase() == "support";
  }
}

class Chatbubble {
  Chatbubble({
    this.friendlyjokes,
    this.historyid,
    this.viewstatus,
  });

  factory Chatbubble.fromJson(Map<String, dynamic> json) => Chatbubble(
    friendlyjokes: asT<String?>(json['friendlyJokes']),
    historyid: asT<String?>(json['historyId']),
    viewstatus: asT<int?>(json['viewStatus']),
  );

  String? friendlyjokes;
  String? historyid;
  int? viewstatus;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'friendlyJokes': friendlyjokes,
    'historyId': historyid,
    'viewStatus': viewstatus,
  };
}


