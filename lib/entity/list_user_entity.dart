import 'dart:convert';
import 'package:voices_dating/entity/user_photo_entity.dart';
import 'package:voices_dating/entity/user_voice_entity.dart';

import '../utils/config_options_utils.dart';
import 'json_format/json_format.dart';

class ListUserEntity {
  ListUserEntity({
    this.age,
    this.avatar,
    this.blockedMe,
    this.body,
    this.canUnlockLikedMe,
    this.canWink,
    this.created,
    this.curLocation,
    this.disability,
    this.distance,
    this.ethnicity,
    this.gender,
    this.haveKids,
    this.headline,
    this.height,
    this.hidden,
    this.hiddenCurrentLocation,
    this.hiddenDisability,
    this.hiddenGender,
    this.hiddenOnline,
    this.income,
    this.isNew,
    this.lastActiveTime,
    this.lastTimeline,
    this.likeMeType,
    this.likeType,
    this.liked,
    this.likedMe,
    this.location,
    this.marital,
    this.member,
    this.online,
    this.photoCnt,
    this.regDays,
    this.roomId,
    this.superLikeMeCnt,
    this.timeLineStatus,
    this.unlocked,
    this.unlockedLikedMe,
    this.userId,
    this.username,
    this.verified,
    this.verifiedIncome,
    this.videoCnt,
    this.videoList,
    this.winked,
    this.winkedMe,
    this.visitedMeCnt,
    this.language,
    this.matchLanguage,
    this.photos, // 新增字段用于存储图片信息
    this.voice,
  });

  factory ListUserEntity.fromJson(Map<String, dynamic> json) {
    final List<Object>? lastTimeline =
    json['lastTimeline'] is List ? <Object>[] : null;
    if (lastTimeline != null) {
      for (final dynamic item in json['lastTimeline']!) {
        if (item != null) {
          lastTimeline.add(asT<Object>(item)!);
        }
      }

    }


    final List<Object>? videoList =
    json['videoList'] is List ? <Object>[] : null;
    if (videoList != null) {
      for (final dynamic item in json['videoList']!) {
        if (item != null) {
          videoList.add(asT<Object>(item)!);
        }
      }
    }
     UserVoiceEntity? voice;
    if (json['voice'] != null) {
      if (json['voice'] is Map<String, dynamic>) {
        voice = UserVoiceEntity.fromJson(json['voice']);
      } else if (json['voice'] is List) {
        final voiceList = json['voice'] as List;
        if (voiceList.isNotEmpty) {
          voice = UserVoiceEntity.fromJson(voiceList.first);
        }
      }
    }

    final List<UserPhotoEntity>? photos = json['photos'] is List ? <UserPhotoEntity>[] : null;
    if (photos != null) {
      for (final dynamic item in json['photos']!) {
        if (item != null) {
          photos.add(UserPhotoEntity.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return ListUserEntity(
      age: asT<String?>(json['age']),
      avatar: asT<String?>(json['avatar']),
      blockedMe: asT<int?>(json['blockedMe']),
      body: asT<int?>(json['body']),
      canUnlockLikedMe: asT<bool?>(json['canUnlockLikedMe']),
      canWink: asT<int?>(json['canWink']),
      created: asT<int?>(json['created']),
      curLocation: json['curLocation'] == null
          ? null
          : CurrentLocation.fromJson(
          asT<Map<String, dynamic>>(json['curLocation'])!),
      disability: asT<String?>(json['disability']),
      distance: asT<String?>(json['distance']),
      ethnicity: asT<int?>(json['ethnicity']),
      gender: asT<String?>(json['gender']),
      haveKids: asT<int?>(json['haveKids']),
      headline: asT<String?>(json['headline']),
      height: asT<int?>(json['height']),
      hidden: asT<String?>(json['hidden']),
      hiddenCurrentLocation: asT<String?>(json['hiddenCurrentLocation']),
      hiddenDisability: asT<String?>(json['hiddenDisability']),
      hiddenGender: asT<String?>(json['hiddenGender']),
      hiddenOnline: asT<String?>(json['hiddenOnline']),
      income: asT<String?>(json['income']),
      isNew: asT<String?>(json['isNew']),
      lastActiveTime: asT<int?>(json['lastActiveTime']),
      lastTimeline: lastTimeline,
      voice: voice,
      likeMeType: asT<int?>(json['likeMeType']),
      likeType: asT<int?>(json['likeType']),
      liked: asT<int?>(json['liked']),
      likedMe: asT<int?>(json['likedMe']),
      location: json['location'] == null
          ? null
          : Location.fromJson(asT<Map<String, dynamic>>(json['location'])!),
      marital: asT<int?>(json['marital']),
      member: asT<String?>(json['member']),
      online: asT<String?>(json['online']),
      photoCnt: asT<String?>(json['photoCnt']),
      photos: photos,
      regDays: asT<int?>(json['regDays']),
      roomId: asT<String?>(json['roomId']),
      superLikeMeCnt: asT<int?>(json['superLikeMeCnt']),
      timeLineStatus: asT<String?>(json['timeLineStatus']),
      unlocked: asT<int?>(json['unlocked']),
      unlockedLikedMe: asT<int?>(json['unlockedLikedMe']),
      userId: asT<String?>(json['userId']),
      username: asT<String?>(json['username']),
      verified: asT<String?>(json['verified']),
      verifiedIncome: asT<String?>(json['verifiedIncome']),
      videoCnt: asT<int?>(json['videoCnt']),
      videoList: videoList,
      winked: asT<int?>(json['winked']),
      winkedMe: asT<int?>(json['winkedMe']),
      visitedMeCnt: asT<String?>(json['visitedMeCnt']),
      language: asT<String?>(json['language']),
      matchLanguage: asT<String?>(json['matchLanguage']),

    );
  }

  String? age;
  String? avatar;
  int? blockedMe;
  int? body;
  bool? canUnlockLikedMe;
  int? canWink;
  int? created;
  CurrentLocation? curLocation;
  String? disability;
  String? distance;
  int? ethnicity;
  String? gender;
  int? haveKids;
  String? headline;
  int? height;
  String? hidden;
  String? hiddenCurrentLocation;
  String? hiddenDisability;
  String? hiddenGender;
  String? hiddenOnline;
  String? income;
  String? isNew;
  int? lastActiveTime;
  List<Object>? lastTimeline;
  int? likeMeType;
  int? likeType;
  int? liked;
  int? likedMe;
  Location? location;
  int? marital;
  String? member;
  String? online;
  String? photoCnt;
  List<UserPhotoEntity>? photos; // 添加存储图片信息的字段
  int? regDays;
  String? roomId;
  int? superLikeMeCnt;
  String? timeLineStatus;
  int? unlocked;
  int? unlockedLikedMe;
  String? userId;
  String? username;
  String? verified;
  String? verifiedIncome;
  int? videoCnt;
  List<Object>? videoList;
  int? winked;
  int? winkedMe;
  String? visitedMeCnt;
  String? language;
  String? matchLanguage;
  UserVoiceEntity?voice;


  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'age': age,
    'avatar': avatar,
    'blockedMe': blockedMe,
    'body': body,
    'canUnlockLikedMe': canUnlockLikedMe,
    'canWink': canWink,
    'created': created,
    'curLocation': curLocation,
    'disability': disability,
    'distance': distance,
    'ethnicity': ethnicity,
    'gender': gender,
    'haveKids': haveKids,
    'headline': headline,
    'height': height,
    'hidden': hidden,
    'hiddenCurrentLocation': hiddenCurrentLocation,
    'hiddenDisability': hiddenDisability,
    'hiddenGender': hiddenGender,
    'hiddenOnline': hiddenOnline,
    'income': income,
    'isNew': isNew,
    'lastActiveTime': lastActiveTime,
    'lastTimeline': lastTimeline,
    'likeMeType': likeMeType,
    'likeType': likeType,
    'liked': liked,
    'likedMe': likedMe,
    'location': location,
    'marital': marital,
    'member': member,
    'online': online,
    'photoCnt': photoCnt,
    'regDays': regDays,
    'roomId': roomId,
    'superLikeMeCnt': superLikeMeCnt,
    'timeLineStatus': timeLineStatus,
    'unlocked': unlocked,
    'unlockedLikedMe': unlockedLikedMe,
    'userId': userId,
    'username': username,
    'verified': verified,
    'verifiedIncome': verifiedIncome,
    'videoCnt': videoCnt,
    'videoList': videoList,
    'winked': winked,
    'winkedMe': winkedMe,
    'visitedMeCnt': visitedMeCnt,
    'language': language,
    'matchLanguage': matchLanguage,
    'photos': photos,
    'voice':voice
  };

  String getUserBasicInfo() {
    StringBuffer buffer = StringBuffer();
    buffer.write(username);

    buffer.write(", ${getGenderStr()}");
    buffer.write(", ${age ?? 42}");
    return buffer.toString();
  }

  String getGenderStr() =>
      ConfigOptionsUtils.getValueByKey(type: ProfileType.gender,
          key: int.tryParse(gender ?? "") ?? 0);
}



class CurrentLocation {
  CurrentLocation({
    this.countAbbr,
    this.countCode,
    this.curAddress,
    this.curCity,
    this.curCityId,
    this.curCountry,
    this.curCountryId,
    this.curState,
    this.curStateId,
  });

  factory CurrentLocation.fromJson(Map<String, dynamic> json) => CurrentLocation(
    countAbbr: asT<String?>(json['countAbbr']),
    countCode: asT<String?>(json['countCode']),
    curAddress: asT<String?>(json['curAddress']),
    curCity: asT<String?>(json['curCity']),
    curCityId: asT<String?>(json['curCityId']),
    curCountry: asT<String?>(json['curCountry']),
    curCountryId: asT<String?>(json['curCountryId']),
    curState: asT<String?>(json['curState']),
    curStateId: asT<String?>(json['curStateId']),
  );

  String? countAbbr;
  String? countCode;
  String? curAddress;
  String? curCity;
  String? curCityId;
  String? curCountry;
  String? curCountryId;
  String? curState;
  String? curStateId;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'countAbbr': countAbbr,
    'countCode': countCode,
    'curAddress': curAddress,
    'curCity': curCity,
    'curCityId': curCityId,
    'curCountry': curCountry,
    'curCountryId': curCountryId,
    'curState': curState,
    'curStateId': curStateId,
  };
}

class Location {
  Location({
    this.city,
    this.cityId,
    this.countAbbr,
    this.countCode,
    this.country,
    this.countryId,
    this.state,
    this.stateAbbr,
    this.stateId,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    city: asT<String?>(json['city']),
    cityId: asT<String?>(json['cityId']),
    countAbbr: asT<String?>(json['countAbbr']),
    countCode: asT<String?>(json['countCode']),
    country: asT<String?>(json['country']),
    countryId: asT<String?>(json['countryId']),
    state: asT<String?>(json['state']),
    stateAbbr: asT<String?>(json['stateAbbr']),
    stateId: asT<String?>(json['stateId']),
  );

  String? city;
  String? cityId;
  String? countAbbr;
  String? countCode;
  String? country;
  String? countryId;
  String? state;
  String? stateAbbr;
  String? stateId;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'city': city,
    'cityId': cityId,
    'countAbbr': countAbbr,
    'countCode': countCode,
    'country': country,
    'countryId': countryId,
    'state': state,
    'stateAbbr': stateAbbr,
    'stateId': stateId,
  };
}
