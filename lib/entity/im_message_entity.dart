import 'dart:convert';

import 'im_new_message_emtity.dart';
import 'json_format/json_format.dart';

class IMMessageEntity {

  IMMessageEntity({
    this.type,
    this.typeId,
    this.duration,
    this.url,
    this.width,
    this.height,
    this.fromUid,
    this.fromName,
    this.toUid,
    this.content,
    this.time,
    this.messageId,
    this.roomId,
    this.showRecall,
    this.localId,
    this.xInfo,
    this.sendState,
    this.errorCode,
    this.lastMessageCreateTime = 0
    ,
  });

  factory IMMessageEntity.fromJson(Map<String, dynamic> jsonRes) => IMMessageEntity(
    type: asT<String?>(jsonRes['type']),
    typeId: asT<int?>(jsonRes['type_id']),
    duration: asT<int?>(jsonRes['duration']),
    url: asT<String?>(jsonRes['url']),
    width: asT<double?>(jsonRes['width']),
    height: asT<double?>(jsonRes['height']),
    fromUid: asT<String?>(jsonRes['from_uid']),
    fromName: asT<String?>(jsonRes['from_name']),
    toUid: asT<String?>(jsonRes['to_uid']),
    content: asT<String?>(jsonRes['content']) ??
        ///flutter: │ 🐛 IMService,_Data{"type":"error","time":1661320409,"error_code":30003010,
        ///"message":"You can not send message.","local_id":"a5ce3e17-d6b6-4812-a4d5-ffd8e152c339"}
        asT<String?>(jsonRes['message']),
    time: asT<int?>(jsonRes['time']),
    messageId: asT<String?>(jsonRes['message_id']),
    roomId: asT<String?>(jsonRes['room_id']),
    showRecall: asT<int?>(jsonRes['show_recall']),
    localId: asT<String?>(jsonRes['local_id']),
    xInfo: asT<String?>(jsonRes['x_info']),
    sendState: asT<int?>(jsonRes['send_state']),
    errorCode: asT<int?>(jsonRes['error_code']),
    lastMessageCreateTime: asT<int?>(jsonRes['last_check_time']) ?? 0,
  );

  String? type;
  int? typeId;
  int? duration;
  String? url;
  double? width;
  double? height;
  String? fromUid;
  String? fromName;
  String? toUid;
  String? content;
  int? time;
  String? messageId;
  String? roomId;

  //0 接收方  1 发送方
  int? showRecall;
  String? localId;
  String? xInfo;

  ///实时消息，所以默认就是发送成功
  int? sendState = MessageStatusEnum.SEND_SUCCESS.value;
  int? errorCode = 0;

  ///回执对方已读的最近一条message的id
  int lastMessageCreateTime = 0;

  @override
  String toString() {
    return jsonEncode(this);
  }


  Map<String, dynamic> toJson() => <String, dynamic>{
    'type': type,
    'type_id': typeId,
    'duration': duration,
    'url': url,
    'width': width,
    'height': height,
    'from_uid': fromUid,
    'from_name': fromName,
    'to_uid': toUid,
    'content': content,
    'time': time,
    'message_id': messageId,
    'room_id': roomId,
    'show_recall': showRecall,
    'local_id': localId,
    'x_info': xInfo,
    //'send_state': sendState,
    'error_code': errorCode,
    'last_check_time': lastMessageCreateTime,
  };

  //{"type":"say","type_id":1,"duration":0,"url":"","
  // width":0,"height":0,"from_uid":"2038426","from_name":"dalton","to_uid":"2031187",
  // "content":"yrururu","time":1661305983,"message_id":"11832346",
  // "room_id":"87a18bb0d35dcf17fba0425f9f2fa7a4","show_recall":1,
  // "local_id":"9d718d27-6deb-44c5-a4ba-5de9ab97de2f","x_info":"","contentCheckRs":false}
  IMNewMessageEntity toIMNewMessageEntity(Sender sender) =>
      IMNewMessageEntity(
          messageType: typeId,
          duration: duration.toString(),
          url: url,
          width: width,
          height: height,
          message: content,
          historyId: messageId,
          created: time!,
          sendState: MessageStatusEnum.SEND_SUCCESS.value,
          sender: sender);

  IMMessageEntity clone() => IMMessageEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}