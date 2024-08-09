// ignore_for_file: constant_identifier_names

import 'dart:convert';
import '../service/app_service.dart';
import 'im_message_entity.dart';
import 'json_format/json_format.dart';
import 'location_entity.dart';
import '../utils/string_extension.dart';

enum MessageStatusEnum {
  SENDING(1),
  SEND_SUCCESS(2),
  SEND_FAILED(3),
  SYSTEM_ERROR(4),
  READ(5);

  final int value;

  const MessageStatusEnum(this.value);

  @override
  String toString() => 'The $name type is $value';
}

class IMNewMessageEntity {
  IMNewMessageEntity({
    this.created = 0,
    this.duration,
    this.historyId,
    this.message = "",
    this.messageType,
    this.profId,
    this.roomId,
    this.sender,
    this.url,
    this.userId,
    this.height,
    this.width,
    this.shouldShowTime = false,
    this.sendState = 0,
    //this.assetEntity,
    String? localId,
  });

  factory IMNewMessageEntity.fromJson(Map<String, dynamic> jsonRes) =>
      IMNewMessageEntity(
          created: asT<int?>(jsonRes['created']) ?? 0,
          duration: asT<String?>(jsonRes['duration']),
          historyId: asT<String?>(jsonRes['historyId']),
          message: asT<String?>(jsonRes['message']) ?? "",
          messageType: asT<int?>(jsonRes['messageType']),
          profId: asT<String?>(jsonRes['profId']),
          roomId: asT<String?>(jsonRes['roomId']),
          sender: jsonRes['sender'] == null
              ? null
              : Sender.fromJson(asT<Map<String, dynamic>>(jsonRes['sender'])!),
          url: asT<String?>(jsonRes['url']),
          userId: asT<String?>(jsonRes['userId']),
          height: asT<double?>(jsonRes['height']),
          width: asT<double?>(jsonRes['width']),
          shouldShowTime: asT<bool?>(jsonRes['shouldShowTime']) ?? false,
          sendState: asT<int?>(jsonRes['sendState']) ?? 0,
          // assetEntity: asT<AssetEntity?>(jsonRes['assetEntity']),
          localId: asT<String?>(jsonRes['local_id']));

  int created;
  String? duration;
  String? historyId;
  String? message;
  int? messageType;
  String? profId;
  String? roomId;
  Sender? sender;
  String? url;
  String? userId;
  double? height;
  double? width;
  bool shouldShowTime; //本地字段，判断是否在聊天列表显示时间
  int? sendState = 0; //本地字段，判断消息是否发送成功
  String? localId;
  // AssetEntity? assetEntity;//本地字段，判断发送的图片

  @override
    String toString() {
      return jsonEncode(this);
    }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'created': created,
    'duration': duration,
    'historyId': historyId,
    'message': message,
    'messageType': messageType,
    'profId': profId,
    'roomId': roomId,
    'sender': sender,
    'url': url,
    'userId': userId,
    'height': height,
    'width': width,
    'shouldShowTime': shouldShowTime,
    'sendState': sendState,
    // 'assetEntity': assetEntity
  };

  IMNewMessageEntity clone() => IMNewMessageEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);

  IMMessageEntity toMessageEntity({String? localId = ""}) => IMMessageEntity(
      typeId: messageType,
      duration: duration == null ? 0 : int.parse(duration!),
      url: url,
      width: width,
      height: height,
      fromUid: sender?.profile?.userId,
      toUid: (sender?.profile?.userId ==
          AppService.instance.selfUser?.userId)
          ? sender?.profile?.userId
          :  AppService.instance.selfUser?.userId,
      content: message,
      time: created,
      messageId: historyId,
      roomId: roomId,
      localId: localId,
      sendState: 0
      );
}

class Sender {
  Sender({
    this.location,
    this.profile,
  });

  factory Sender.fromJson(Map<String, dynamic> jsonRes) => Sender(
    location: jsonRes['location'] == null
        ? null
        : LocationEntity.fromJson(
        asT<Map<String, dynamic>>(jsonRes['location'])!),
    profile: jsonRes['profile'] == null
        ? null
        : Profile.fromJson(asT<Map<String, dynamic>>(jsonRes['profile'])!),
  );

  LocationEntity? location;
  Profile? profile;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'location': location,
    'profile': profile,
  };

  Sender clone() =>
      Sender.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Profile {
  Profile({
    this.about,
    this.age,
    this.avatarUrl,
    this.gender,
    this.member,
    this.online,
    this.thumbUrl,
    this.userId,
    this.username,
    this.verified,
    this.status = 0,
  });

  factory Profile.fromJson(Map<String, dynamic> jsonRes) => Profile(
    about: asT<String?>(jsonRes['about']),
    age: asT<String?>(jsonRes['age']),
    avatarUrl: asT<String?>(jsonRes['avatarUrl']),
    gender: asT<String?>(jsonRes['gender']),
    member: asT<String?>(jsonRes['member']),
    online: asT<String?>(jsonRes['online']),
    thumbUrl: asT<String?>(jsonRes['thumbUrl']),
    status: asT<int?>(jsonRes['status']),
    verified: asT<String?>(jsonRes['verified']),
    userId: asT<String?>(jsonRes['userId']),
    username: asT<String?>(jsonRes['username']).firstUpperCase,
  );

  String? about;
  String? age;
  String? avatarUrl;
  String? gender;
  String? member;
  String? online;
  String? thumbUrl;
  String? userId;
  String? username;

  //profile status, 0: pending, 1: approved, 2: refused, 3: blocked, 4: removed, 5: on hold
  int? status;
  String? verified;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'about': about,
    'age': age,
    'avatarUrl': avatarUrl,
    'gender': gender,
    'member': member,
    'online': online,
    'thumbUrl': thumbUrl,
    'status': status,
    'verified': verified,
    'userId': userId,
    'username': username,
  };

  Profile clone() => Profile.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

