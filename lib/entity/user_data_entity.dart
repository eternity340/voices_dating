import 'dart:convert';
import 'package:first_app/utils/string_extension.dart';
import '../constants/constant_data.dart';
import '../utils/config_options_utils.dart';
import 'json_format/json_format.dart';
import 'match_age_entity.dart';
import 'moment_entity.dart';
import 'partner_info_entity.dart';
import 'profile_comment_entity.dart';
import 'prompt_no_photo_entity.dart';
import 'user_location_entity.dart';
import 'user_photo_entity.dart';



class UserDataEntity {
  UserDataEntity({
    this.about,
    this.age,
    this.agreeGuidelines,
    this.autoRenew,
    this.avatar,
    this.averageScores,
    this.birthday,
    this.body,
    this.canSendVerifyPhoto,
    this.canWink,
    this.changedGender,
    this.created,
    this.curLocation,
    this.defaultWinkTypeId,
    this.drink,
    this.education,
    this.email,
    this.emailUnsubscribe,
    this.emailVerified,
    this.ethnicity,
    this.expiredDate,
    this.eyes,
    this.facebookUid,
    this.favoriteMusic,
    this.fraudStatus,
    this.gender,
    this.googlePlayNotifyStatus,
    this.googleUid,
    this.hair,
    this.hasSubscription,
    this.haveChildren,
    this.headline,
    this.height,
    this.hidden,
    this.hiddenCurrentLocation,
    this.hiddenGender,
    this.hiddenLogin,
    this.hiddenOnline,
    this.hiddenView,
    this.hobby,
    this.hometown,
    this.hp,
    this.ignoreFraudStatus,
    this.income,
    this.language,
    this.turnOns,
    this.eroticFun,
    this.lastPayWay,
    this.lastProfileComment,
    this.lastTimeline,
    this.allTimeline,
    this.liked,
    this.likedCntToday,
    this.likedMe,
    this.location,
    this.marital,
    this.matchAbout,
    this.matchAge,
    this.partnerInfo,
    this.matchAnywhere,
    this.matchCityId,
    this.matchCountryId,
    this.matchDistance,
    this.matchGender,
    this.matchIncome,
    this.matchRelationship,
    this.matchStateId,
    this.member,
    this.myScores,
    this.noticeLike,
    this.noticeMessage,
    this.noticeView,
    this.occupation,
    this.online,
    this.paymentStartDate,
    this.perfectDate,
    this.perfectLikeCnt,
    this.perfectLikeList,
    this.personality,
    this.pet,
    this.phone,
    this.phoneCountry,
    this.phoneVerified,
    this.photos,
    this.politicalBelief,
    this.privateAlbum,
    this.profileCommentNumber,
    this.profilePending,
    this.profileVideo,
    this.promptIfNoPhoto,
    this.relation,
    this.religion,
    this.remainingDay,
    this.sign,
    this.smoke,
    this.tlsSig,
    this.totalScorer,
    this.userId,
    this.username = "",
    this.verified,
    this.wantChildren,
    this.winked,
    this.visitedMeCnt,
    this.lastMessage = "",
    this.lastMessageSenderId,
    this.messageType = 1,
    this.status = 0,
    this.sentMessageStatus = -1,
    this.newNumber = 0,
    this.lastCacheTime = 0,
    this.changedBirthday = "",
    this.matchLanguage,
    this.switchedAbbr = "",
    this.appleTag = false,

  });

  factory UserDataEntity.fromJson(Map<String, dynamic> jsonRes) {
    final List<ProfileCommentEntity>? lastProfileComment =
    jsonRes['lastProfileComment'] is List ? <ProfileCommentEntity>[] : null;
    if (lastProfileComment != null) {
      for (final dynamic item in jsonRes['lastProfileComment']!) {
        if (item != null) {
          tryCatch(() {
            lastProfileComment.add(asT<ProfileCommentEntity>(item)!);
          });
        }
      }
    }

    final List<MomentEntity>? lastTimeline =
    jsonRes['lastTimeline'] is List ? <MomentEntity>[] : null;
    if (lastTimeline != null) {
      for (final dynamic item in jsonRes['lastTimeline']!) {
        if (item != null) {
          tryCatch(() {
            lastTimeline.add(asT<MomentEntity>(item)!);
          });
        }
      }
    }

    final List<MomentEntity>? allTimeline =
    jsonRes['allTimeline'] is List ? <MomentEntity>[] : null;
    if (allTimeline != null) {
      for (final dynamic item in jsonRes['allTimeline']!) {
        if (item != null) {
          tryCatch(() {
            allTimeline.add(asT<MomentEntity>(item)!);
          });
        }
      }
    }

    final List<Object>? perfectDate =
    jsonRes['perfectDate'] is List ? <Object>[] : null;
    if (perfectDate != null) {
      for (final dynamic item in jsonRes['perfectDate']!) {
        if (item != null) {
          tryCatch(() {
            perfectDate.add(asT<Object>(item)!);
          });
        }
      }
    }

    final List<Object>? perfectLikeList =
    jsonRes['perfectLikeList'] is List ? <Object>[] : null;
    if (perfectLikeList != null) {
      for (final dynamic item in jsonRes['perfectLikeList']!) {
        if (item != null) {
          tryCatch(() {
            perfectLikeList.add(asT<Object>(item)!);
          });
        }
      }
    }

    final List<UserPhotoEntity>? photos =
    jsonRes['photos'] is List ? <UserPhotoEntity>[] : null;
    if (photos != null) {
      for (final dynamic item in jsonRes['photos']!) {
        if (item != null) {
          tryCatch(() {
            photos.add(UserPhotoEntity.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<UserPhotoEntity>? privateAlbum =
    jsonRes['privateAlbum'] is List ? <UserPhotoEntity>[] : null;
    if (privateAlbum != null) {
      for (final dynamic item in jsonRes['privateAlbum']!) {
        if (item != null) {
          tryCatch(() {
            privateAlbum
                .add(UserPhotoEntity.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<Object>? profileVideo =
    jsonRes['profileVideo'] is List ? <Object>[] : null;
    if (profileVideo != null) {
      for (final dynamic item in jsonRes['profileVideo']!) {
        if (item != null) {
          tryCatch(() {
            profileVideo.add(asT<Object>(item)!);
          });
        }
      }
    }


    return UserDataEntity(
      about: asT<String?>(jsonRes['about']),
      age: asT<String?>(jsonRes['age']),
      agreeGuidelines: asT<String?>(jsonRes['agreeGuidelines']),
      autoRenew: asT<int?>(jsonRes['autoRenew']),
      avatar: asT<String?>(jsonRes['avatar']),
      averageScores: asT<String?>(jsonRes['averageScores']),
      birthday: asT<int?>(jsonRes['birthday']),
      body: asT<String?>(jsonRes['body']),
      canSendVerifyPhoto: asT<int?>(jsonRes['canSendVerifyPhoto']),
      canWink: asT<int?>(jsonRes['canWink']),
      changedGender: asT<String?>(jsonRes['changedGender']),
      created: asT<int?>(jsonRes['created']),
      curLocation: jsonRes['curLocation'] == null
          ? null
          : UserLocationEntity.fromJson(
          asT<Map<String, dynamic>>(jsonRes['curLocation'])!),
      defaultWinkTypeId: asT<String?>(jsonRes['defaultWinkTypeId']),
      drink: asT<String?>(jsonRes['drink']),
      education: asT<String?>(jsonRes['education']),
      email: asT<String?>(jsonRes['email']),
      emailUnsubscribe: asT<String?>(jsonRes['emailUnsubscribe']),
      emailVerified: asT<String?>(jsonRes['emailVerified']),
      ethnicity: asT<String?>(jsonRes['ethnicity']),
      expiredDate: asT<int?>(jsonRes['expiredDate']),
      eyes: asT<String?>(jsonRes['eyes']),
      facebookUid: asT<String?>(jsonRes['facebookUid']),
      favoriteMusic: asT<String?>(jsonRes['favoriteMusic']),
      fraudStatus: asT<String?>(jsonRes['fraudStatus']),
      gender: asT<String?>(jsonRes['gender']),
      googlePlayNotifyStatus: asT<Object?>(jsonRes['googlePlayNotifyStatus']),
      googleUid: asT<String?>(jsonRes['googleUid']),
      hair: asT<String?>(jsonRes['hair']),
      hasSubscription: asT<bool?>(jsonRes['hasSubscription']),
      haveChildren: asT<String?>(jsonRes['haveChildren']),
      headline: asT<String?>(jsonRes['headline']),
      height: asT<String?>(jsonRes['height']),
      hidden: asT<String?>(jsonRes['hidden']),
      hiddenCurrentLocation: asT<String?>(jsonRes['hiddenCurrentLocation']),
      hiddenGender: asT<String?>(jsonRes['hiddenGender']),
      hiddenLogin: asT<String?>(jsonRes['hiddenLogin']),
      hiddenOnline: asT<String?>(jsonRes['hiddenOnline']),
      hiddenView: asT<String?>(jsonRes['hiddenView']),
      hobby: asT<String?>(jsonRes['hobby']),
      hometown: asT<String?>(jsonRes['hometown']),
      hp: asT<String?>(jsonRes['hp']),
      ignoreFraudStatus: asT<String?>(jsonRes['ignoreFraudStatus']),
      income: asT<String?>(jsonRes['income']),
      language: asT<String?>(jsonRes['language']),
      eroticFun: asT<String?>(jsonRes['eroticFun']),
      turnOns: asT<String?>(jsonRes['turnOns']),
      lastPayWay: asT<String?>(jsonRes['lastPayWay']),
      lastProfileComment: lastProfileComment,
      lastTimeline: lastTimeline,
      allTimeline: allTimeline,
      liked: asT<int?>(jsonRes['liked']),
      likedCntToday: asT<int?>(jsonRes['likedCntToday']),
      likedMe: asT<int?>(jsonRes['likedMe']),
      location: jsonRes['location'] == null
          ? null
          : UserLocationEntity.fromJson(
          asT<Map<String, dynamic>>(jsonRes['location'])!),
      marital: asT<String?>(jsonRes['marital']),
      matchAbout: asT<String?>(jsonRes['matchAbout']),
      matchAge: jsonRes['matchAge'] == null
          ? null
          : MatchAgeEntity.fromJson(
          asT<Map<String, dynamic>>(jsonRes['matchAge'])!),
      partnerInfo: (jsonRes['partnerInfo'].toString() == "[]" || jsonRes['partnerInfo'] == null)
          ? null
          : PartnerInfoEntity.fromJson(
          asT<Map<String, dynamic>>(jsonRes['partnerInfo'])!),
      matchAnywhere: asT<String?>(jsonRes['matchAnywhere']),
      matchCityId: asT<String?>(jsonRes['matchCityId']),
      matchCountryId: asT<String?>(jsonRes['matchCountryId']),
      matchDistance: asT<String?>(jsonRes['matchDistance']),
      matchGender: asT<String?>(jsonRes['matchGender']),
      matchIncome: asT<String?>(jsonRes['matchIncome']),
      matchRelationship: asT<String?>(jsonRes['matchRelationship']),
      matchStateId: asT<String?>(jsonRes['matchStateId']),
      member: asT<String?>(jsonRes['member']),
      myScores: asT<String?>(jsonRes['myScores']),
      noticeLike: asT<String?>(jsonRes['noticeLike']),
      noticeMessage: asT<String?>(jsonRes['noticeMessage']),
      noticeView: asT<String?>(jsonRes['noticeView']),
      occupation: asT<String?>(jsonRes['occupation']),
      online: asT<String?>(jsonRes['online']),
      paymentStartDate: asT<int?>(jsonRes['paymentStartDate']),
      perfectDate: perfectDate,
      perfectLikeCnt: asT<int?>(jsonRes['perfectLikeCnt']),
      perfectLikeList: perfectLikeList,
      personality: asT<String?>(jsonRes['personality']),
      pet: asT<String?>(jsonRes['pet']),
      phone: asT<String?>(jsonRes['phone']),
      phoneCountry: asT<String?>(jsonRes['phoneCountry']),
      phoneVerified: asT<String?>(jsonRes['phoneVerified']),
      photos: photos,
      politicalBelief: asT<String?>(jsonRes['politicalBelief']),
      privateAlbum: privateAlbum,
      profileCommentNumber: asT<String?>(jsonRes['profileCommentNumber']),
      profilePending: asT<int?>(jsonRes['profilePending']),
      profileVideo: profileVideo,
      promptIfNoPhoto: jsonRes['promptIfNoPhoto'] == null
          ? null
          : PromptNoPhotoEntity.fromJson(
          asT<Map<String, dynamic>>(jsonRes['promptIfNoPhoto'])!),
      relation: asT<String?>(jsonRes['relation']),
      religion: asT<String?>(jsonRes['religion']),
      remainingDay: asT<int?>(jsonRes['remainingDay']),
      sign: asT<String?>(jsonRes['sign']),
      smoke: asT<String?>(jsonRes['smoke']),
      tlsSig: asT<String?>(jsonRes['tlsSig']),
      totalScorer: asT<String?>(jsonRes['totalScorer']),
      userId: asT<String?>(jsonRes['userId']),
      username:
      asT<String?>(jsonRes['username'])?? "",
      verified: asT<String?>(jsonRes['verified']),
      wantChildren: asT<String?>(jsonRes['wantChildren']),
      winked: asT<int?>(jsonRes['winked']),
      visitedMeCnt: asT<int?>(jsonRes['visitedMeCnt'], 1),
      lastMessage: asT<String?>(jsonRes['lastMessage']) ?? "",
      lastMessageSenderId: asT<String?>(jsonRes['lastMessageSenderId']),
      messageType: asT<int?>(jsonRes['messageType']) ?? 1,
      status: asT<int?>(jsonRes['status']) ?? 0,
      sentMessageStatus: asT<int?>(jsonRes['sentMessageStatus']) ?? -1,
      newNumber: asT<int?>(jsonRes['newNumber']) ?? 0,
      changedBirthday: asT<String?>(jsonRes['changedBirthday']) ?? "0",
      matchLanguage: asT<String?>(jsonRes['matchLanguage']) ?? "0",
      switchedAbbr: asT<String?>(jsonRes['switchedAbbr']) ?? "",
      appleTag: asT<bool?>(jsonRes['apple_tag']) ?? false,
    );
  }

  String? about;
  String? age;
  String? agreeGuidelines;
  int? autoRenew;
  String? avatar;
  String? averageScores;
  int? birthday;
  String? body;
  int? canSendVerifyPhoto;
  int? canWink;
  String? changedGender;
  int? created;
  UserLocationEntity? curLocation;
  String? defaultWinkTypeId;
  String? drink;
  String? education;
  String? email;
  String? emailUnsubscribe;
  String? emailVerified;
  String? ethnicity;
  int? expiredDate;
  String? eyes;
  String? facebookUid;
  String? favoriteMusic;
  String? fraudStatus;
  String? gender;
  Object? googlePlayNotifyStatus;
  String? googleUid;
  String? hair;
  bool? hasSubscription;
  String? haveChildren;
  String? headline;
  String? height;
  String? hidden;
  String? hiddenCurrentLocation;
  String? hiddenGender;
  String? hiddenLogin;
  String? hiddenOnline;
  String? hiddenView;
  String? hobby;
  String? hometown;
  String? hp;
  String? ignoreFraudStatus;
  String? income;
  String? language;
  String? turnOns;
  String? eroticFun;
  String? lastPayWay;
  List<ProfileCommentEntity>? lastProfileComment;
  List<MomentEntity>? lastTimeline;
  List<MomentEntity>? allTimeline;
  int? liked;
  int? likedCntToday;
  int? likedMe;
  UserLocationEntity? location;
  String? marital;
  String? matchAbout;
  MatchAgeEntity? matchAge;
  PartnerInfoEntity? partnerInfo;
  String? matchAnywhere;
  String? matchCityId;
  String? matchCountryId;
  String? matchDistance;
  String? matchGender;
  String? matchIncome;
  String? matchRelationship;
  String? matchStateId;
  String? member;
  String? myScores;
  String? noticeLike;
  String? noticeMessage;
  String? noticeView;
  String? occupation;
  String? online;
  int? paymentStartDate;
  List<Object>? perfectDate;
  int? perfectLikeCnt;
  List<Object>? perfectLikeList;
  String? personality;
  String? pet;
  String? phone;
  String? phoneCountry;
  String? phoneVerified;
  List<UserPhotoEntity>? photos;
  String? politicalBelief;
  List<UserPhotoEntity>? privateAlbum;
  String? profileCommentNumber;
  int? profilePending;
  List<Object>? profileVideo;
  PromptNoPhotoEntity? promptIfNoPhoto;
  String? relation;
  String? religion;
  int? remainingDay;
  String? sign;
  String? smoke;
  String? tlsSig;
  String? totalScorer;
  String? userId;
  String username;
  String? verified;
  String? wantChildren;
  int? winked;
  int? visitedMeCnt;
  String lastMessage;
  String? lastMessageSenderId;
  String? changedBirthday;
  String? matchLanguage;
  String? switchedAbbr;
  bool? appleTag;

  // default 1, 1 - text, 2 - image, 3 - radio, 4 - video, 5 - like, 6 - match, 7 - wink,
  //  8 - private album request, 9 - accept private album request, 10 - first date ideas' 11 recall
  //  12, 邀请他人上传照片 ，13 support消息：upgrade送boost;
  int messageType = 1;

  //profile status, 0: pending, 1: approved, 2: refused, 3: blocked, 4: removed, 5: on hold
  int status = 0;

  //未建立连接定义：A发送消息给B，B还未回复A消息的状态  0 ：接收方未回复过消息的状态
  int sentMessageStatus = -1;

  // 未读消息
  int newNumber = -1;

  int lastCacheTime = 0;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'about': about,
    'age': age,
    'agreeGuidelines': agreeGuidelines,
    'autoRenew': autoRenew,
    'avatar': avatar,
    'averageScores': averageScores,
    'birthday': birthday,
    'body': body,
    'canSendVerifyPhoto': canSendVerifyPhoto,
    'canWink': canWink,
    'changedGender': changedGender,
    'created': created,
    'curLocation': curLocation?.toJson(),
    'defaultWinkTypeId': defaultWinkTypeId,
    'drink': drink,
    'education': education,
    'email': email,
    'emailUnsubscribe': emailUnsubscribe,
    'emailVerified': emailVerified,
    'ethnicity': ethnicity,
    'expiredDate': expiredDate,
    'eyes': eyes,
    'facebookUid': facebookUid,
    'favoriteMusic': favoriteMusic,
    'fraudStatus': fraudStatus,
    'gender': gender,
    'googlePlayNotifyStatus': googlePlayNotifyStatus,
    'googleUid': googleUid,
    'hair': hair,
    'hasSubscription': hasSubscription,
    'haveChildren': haveChildren,
    'headline': headline,
    'height': height,
    'hidden': hidden,
    'hiddenCurrentLocation': hiddenCurrentLocation,
    'hiddenGender': hiddenGender,
    'hiddenLogin': hiddenLogin,
    'hiddenOnline': hiddenOnline,
    'hiddenView': hiddenView,
    'hobby': hobby,
    'hometown': hometown,
    'hp': hp,
    'ignoreFraudStatus': ignoreFraudStatus,
    'income': income,
    'language': language,
    'turnOns': turnOns,
    'eroticFun': eroticFun,
    'lastPayWay': lastPayWay,
    'lastProfileComment': lastProfileComment,
    'lastTimeline': lastTimeline,
    'allTimeline': allTimeline,
    'liked': liked,
    'likedCntToday': likedCntToday,
    'likedMe': likedMe,
    'location': location?.toJson(),
    'marital': marital,
    'matchAbout': matchAbout,
    'matchAge': matchAge,
    'partnerInfo': partnerInfo,
    'matchAnywhere': matchAnywhere,
    'matchCityId': matchCityId,
    'matchCountryId': matchCountryId,
    'matchDistance': matchDistance,
    'matchGender': matchGender,
    'matchIncome': matchIncome,
    'matchRelationship': matchRelationship,
    'matchStateId': matchStateId,
    'member': member,
    'myScores': myScores,
    'noticeLike': noticeLike,
    'noticeMessage': noticeMessage,
    'noticeView': noticeView,
    'occupation': occupation,
    'online': online,
    'paymentStartDate': paymentStartDate,
    'perfectDate': perfectDate,
    'perfectLikeCnt': perfectLikeCnt,
    'perfectLikeList': perfectLikeList,
    'personality': personality,
    'pet': pet,
    'phone': phone,
    'phoneCountry': phoneCountry,
    'phoneVerified': phoneVerified,
    'photos': photos,
    'politicalBelief': politicalBelief,
    'privateAlbum': privateAlbum,
    'profileCommentNumber': profileCommentNumber,
    'profilePending': profilePending,
    'profileVideo': profileVideo,
    'promptIfNoPhoto': promptIfNoPhoto,
    'relation': relation,
    'religion': religion,
    'remainingDay': remainingDay,
    'sign': sign,
    'smoke': smoke,
    'tlsSig': tlsSig,
    'totalScorer': totalScorer,
    'userId': userId,
    'username': username,
    'verified': verified,
    'wantChildren': wantChildren,
    'winked': winked,
    'visitedMeCnt': visitedMeCnt,
    'lastMessage': lastMessage,
    'lastMessageSenderId': lastMessageSenderId,
    'messageType': messageType,
    'status': status,
    'sentMessageStatus': sentMessageStatus,
    'newNumber': newNumber,
    'changedBirthday': changedBirthday,
    'matchLanguage': matchLanguage,
    'switchedAbbr': switchedAbbr,
  };

  UserDataEntity clone() => UserDataEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);

  String getLocationStr() => location?.toAddress() ?? "";

  String getGenderStr() => ConfigOptionsUtils.getValueByKey(type:
  ProfileType.gender, key:int.tryParse(gender??"")??0);

  bool needVerify() => verified != ConstantData.userStatusVerified && verified != ConstantData.userStatusPending;

  bool isMember() => !member.isNullOrEmpty&&int.parse(member!)>=1;

  bool canChangeGender() => changedGender !="1";
  bool canChangeBirthday() => changedBirthday !="1";

  String getUserBasicInfo(){
    StringBuffer buffer = StringBuffer();
    buffer.write(username);

    buffer.write(", ${getGenderStr()}");
    buffer.write(", ${age??42}");
    return buffer.toString();
  }

  String getMyLanguageStr() => ConfigOptionsUtils.getValueByCalculatedKey(type:
  ProfileType.language, key:int.tryParse(language??"")??0);
  String getMatchLanguageStr() => ConfigOptionsUtils.getValueByCalculatedKey(type:
  ProfileType.language, key:int.tryParse(matchLanguage??"")??0);

}
