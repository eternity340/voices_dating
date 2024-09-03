// ignore_for_file: constant_identifier_names, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:first_app/service/token_service.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../components/custom_dialog.dart';
import '../constants/constant_data.dart';
import '../entity/im_message_entity.dart';
import '../entity/token_entity.dart';
import '../net/api_constants.dart';
import '../resources/string_res.dart';
import '../utils/common_utils.dart';
import '../utils/log_util.dart';
import '../utils/shared_preference_util.dart';
import 'app_service.dart';

enum ConnectionStatusEnum {
  connecting(0),
  connected(1),
  closed(2);

  final int value;

  const ConnectionStatusEnum(this.value);

  @override
  String toString() => 'The ConnectionStatusEnum $name value is $value';
}

enum MessageTypeEnum {
  CONNECTED("connected"),
  PING("ping"),
  PONG("pong"),
  SAY("say"),
  SAY_TO_GROUP("say_to_group"),
  RECALL("recall"),
  ERROR("error"),
  REPORT("report"),

  /// 连接IM时返回
  GROUP_UID("group_uids"),
  JOIN_GROUP("join_group"),
  LEAVE_GROUP("leave_group"),
  GROUP_CONNECTED("group_connected"),
  GROUP_ERROR("group_error"),
//需要设置的状态.  //Chatroom online status, 1:Online, 2:Offline, 3:Invisible, 4:Busy, 5:Away
  SET_GROUP_STATUS("set_group_status"),
//{type: "check_online", check_uid: 121625785}
//{type: "check_online", check_uid: 121625785, is_online: 0, time: 1654658574}
  CHECK_ONLINE("check_online"),
  UN_KNOW("un_know");

  final String value;

  const MessageTypeEnum(this.value);

  @override
  String toString() => 'The MessageTypeEnum $name value is $value';
}

///1,Text
// 2,Image
// 3,Radio
// 4,Video
// 5,Like
// 6,Match
// 7,Wink
// 8,Private album request
// 9,Accept private album request
// 10,First date ideas
// 11,Recall
// 12,Request upload photo
// 13,Add free boosts
// 14,Upload photos (to who requested upload photo)
// 15,Private album has been updated
// 16,Video chat
// 17,Voice chat
// 18,Gift message
// 19,BoltImage
// 20,Ice breaking quesion
// 21,PREMIUM upgrade to PREMIUM+
// 22,STANDARD upgrade to PREMIUM
// 23,like profile or like user's photo
// 24,System message adds page jump link
// 25,Predefined System message
// 26,Predefined System message
// 27,Graphic wink
// 28,Emoji
// 29,Accept chat invitation
// 30,Shared a chat background
// 31,Accepted the shared background
// 32,like itinerary
// 33,ask join itinerary
// 34,Restore the chat background to original
// 35,Reply to chatroom messages
// 36,like dine companion
// 37,ask join companion
// 38,contest share

enum MessageTypeIdEnum {
  TEXT(1),
  IMAGE(2),
  VOICE(3),
  VIDEO(4),
  LIKE(5),
  MATCH(6),
  // WINK(7),
  // PRIVATE_ALBUM_REQUEST(8),
  // ACCEPT_PRIVATE_ALBUM_REQUEST(9),
  // FIRST_DATE_IDEAS(10),
  MESSAGE_TYPE_RE_CALL(11),
  // MESSAGE_TYPE_REQUEST_UPLOAD_PHOTO(12),
  // MESSAGE_TYPE_GET_BOOST_BY_UPGRADE(13),
  // MESSAGE_TYPE_INVITE_UPLOAD_PHOTO_CHANGES(14),
  // MESSAGE_TYPE_UPLOAD_PRIVATE_PHOTO_NOTIFY_OTHERS(15),


  MESSAGE_TYPE_FOR_RECEIVE(5001),
  MESSAGE_TYPE_UN_KNOW(15001);

  final int value;

  const MessageTypeIdEnum(this.value);

  @override
  String toString() => 'The MessageTypeIdEnum $name value is $value';
}

typedef MessageCallback = Function(IMMessageEntity messageEntity);

class IMService extends GetxService {
  bool isBackground = false;

  ///记录当前ping收到的时间
  int pingInterval = DateTime.now().millisecondsSinceEpoch;

  static IMService get instance => Get.find<IMService>();

  ///重连策略就是间隔1s，2s，3s，5s，8s... 类似一个斐波那契数列，如果超过一个小时，就按一个小时算
  final int maxInterval = 3600000;
  int lastTimeInterval = 0;
  int currentTimeInterval = 1000;

  ///初始状态： 连接中。。。。
  var connectionStatus = (ConnectionStatusEnum.closed).obs;

  ///初始化网络监听不需要重连
  bool needReConnect = false;

  IOWebSocketChannel? channel;
  final List<MessageCallback> _messageCallBack = List.empty(growable: true);

  ///网络变化监听
  //ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final _connectionStatus = (ConnectivityResult.none).obs;

  get netWorkStatus => _connectionStatus.value;

  set netWorkStatus(val) => _connectionStatus.value = val;

  cancelReconnect() {
    lastTimeInterval = 0;
    currentTimeInterval = 1000;
  }

  IMService init(){
    return this;
  }
  @override
  void onInit() {
    super.onInit();
    initConnectivity();

    ///网络变化监听
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      LogUtil.e(message: 'Couldn\'t check connectivity status--$e');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) {
    //   return Future.value(null);
    // }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (AppService.instance.isLogin) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        // I am connected to a mobile network.// I am connected to a wifi network.
        if (connectionStatus.value == ConnectionStatusEnum.closed) {
          if (lastTimeInterval > 0) {
            cancelReconnect();
          }

          if (needReConnect) {
            tryReconnect();
          }
        }
      } else {
        connectionStatus.value = ConnectionStatusEnum.closed;
      }
    }
    _connectionStatus.value = result;
    LogUtil.d(message: "WsManager-----_connectionStatus: + $result");
  }

  ///检测是断开状态就触发重连机制
  tryReconnect() {
    //  /// Possible states of the connection.
    //   static const int connecting = 0;
    //   static const int open = 1;
    //   static const int closing = 2;
    //   static const int closed = 3;
    if(!needReConnect) {
      return;
    }
    LogUtil.d(
        message: "WsManager-----channel?.innerWebSocket?.readyState : ${channel?.innerWebSocket?.readyState}"
            "\n pingInterval:${DateTime.now().millisecondsSinceEpoch - pingInterval > 10 * 1000}");

    ///ping 的默认周期是30秒，如果60秒内都没收到，说明已经断开im链接了

    if (channel?.innerWebSocket?.readyState != WebSocket.open ||
        DateTime.now().millisecondsSinceEpoch - pingInterval >= 60 * 1000) {
      connectionStatus.value = ConnectionStatusEnum.closed;
    }

    if (connectionStatus.value == ConnectionStatusEnum.connected) {
      return;
    }
    LogUtil.d(message: "WsManager-----tryReconnect");
    connectionStatus.value = ConnectionStatusEnum.connecting;
    int retryInterval = lastTimeInterval + currentTimeInterval;
    lastTimeInterval = currentTimeInterval;
    currentTimeInterval = retryInterval;

    LogUtil.d(message: "WsManager-----tryReconnect delay: + $retryInterval");

    Future.delayed(Duration(milliseconds: min(retryInterval, maxInterval)), () {
      buildConnect();
    });
  }

  addMessageCallBack(MessageCallback callback) {
    _messageCallBack.add(callback);
  }

  removeMessageCallBack(MessageCallback callback) {
    _messageCallBack.remove(callback);
  }

  Future connect() async {
    LogUtil.d(message: "WsManager connectionStatus:${connectionStatus.value}");
    if ((connectionStatus.value == ConnectionStatusEnum.connected)) {
      return;
    }
    connectionStatus.value = ConnectionStatusEnum.connecting;
    if (AppService.instance.isLogin) {
      // 从本地存储获取 token
      final tokenJson = SharedPreferenceUtil.instance.getValue(key: SharedPresKeys.userToken);
      String? token;
      if (tokenJson != null) {
        final tokenEntity = TokenEntity.fromJson(json.decode(tokenJson));
        token = tokenEntity.accessToken;
      }
      if (token == null) {
        LogUtil.e(message: "Token not found in SharedPreferences");
        connectionStatus.value = ConnectionStatusEnum.closed;
        return;
      }
      String url = "${ApiConstants.getWsUrl()}?token=$token";
      print("${ApiConstants.getWsUrl()}?token=$token");
      try {
        channel = IOWebSocketChannel.connect(
          url,
          // pingInterval: const Duration(seconds: 5)
        );
        LogUtil.d(message: "WsManager connectionStatus:${connectionStatus.value}");
        channel?.stream.listen(_data, onError: _onError, onDone: _onDone);
      } on UnsupportedError catch (e) {
        connectionStatus.value = ConnectionStatusEnum.closed;
        LogUtil.e(message: "WsManager connect UnsupportedError error: ${e.toString()}");
      } on SocketException catch (e) {
        connectionStatus.value = ConnectionStatusEnum.closed;
        LogUtil.e(message: "WsManager connect SocketException  error: ${e.toString()}");
      }
    } else {
      connectionStatus.value = ConnectionStatusEnum.closed;
      LogUtil.e(message: "WsManager connect: User not logged in");
    }
  }

  _data(event) {
    LogUtil.v(message: "IMService,_Data${event.toString()}");
    Map<String, dynamic> resultData = json.decode(event.toString());
    IMMessageEntity messageEntity = IMMessageEntity.fromJson(resultData);

    var type = MessageTypeEnum.values.firstWhere(
            (element) => element.value == messageEntity.type,
        orElse: () => MessageTypeEnum.UN_KNOW);
    switch (type) {
      case MessageTypeEnum.PING:
        pingInterval = DateTime.now().millisecondsSinceEpoch;
        channel?.sink.add("{\"type\":\"pong\"}");
        break;
      case MessageTypeEnum.PONG:
        channel?.sink.add("{\"type\":\"ping\"}");
        break;
      case MessageTypeEnum.CONNECTED:
        connectionStatus.value = ConnectionStatusEnum.connected;
        needReConnect = true;
        break;
      case MessageTypeEnum.RECALL:
        break;
      case MessageTypeEnum.REPORT:

      ///接收对方已读的消息时间
        break;
      case MessageTypeEnum.ERROR:
      //{"type":"error","time":1606703469,"code":30001029,"message":"The user is unavailable now."}
      //{"type":"error","time":1606703469,"code":30003002,"message":"Input parameters error."}
      //{"type":"error","time":1606703469,"code":10001001,"message":"Please login first"}
        if (resultData.containsKey("message")) {
          CommonUtils.showSnackBar(resultData['message']);
        }
        ///根据local id 更改消息的发送状态为失败
        if (resultData.containsKey("error_code") &&
            resultData["error_code"] == 10001001) {
          needReConnect = false;
          Get.dialog(logInFirstDialogWidget,
              barrierDismissible: false,
              transitionDuration: const Duration(milliseconds: 300));
        }
        break;
      case MessageTypeEnum.CHECK_ONLINE:
        break;
      default:
        break;
    }
    for (MessageCallback listener in _messageCallBack) {
      // print("callbacklenght:${_messageCallBack.length}");
      listener(messageEntity);
    }
  }

  ///
  /// If there's an error connecting, the channel's stream emits a
  /// [WebSocketChannelException] wrapping that error and then closes.
  ///
  /// WebSocketChannelException: WebSocketChannelException: SocketException:
  /// Failed host lookup: 'chat.masonvips.com' (OS Error: No address associated with hostname, errno = 7)
  _onError(error) {
    LogUtil.e(message: "WsManager error:$error");
    if (error is WebSocketChannelException) {
      connectionStatus.value = ConnectionStatusEnum.closed;
      tryReconnect();
    }
  }

  /// If this stream closes and sends a done event, the [onDone] handler is
  /// called. If [onDone] is `null`, nothing happens.
  _onDone() {
    LogUtil.d(message: "WsManager _onDone -----------------");
    if (!AppService.instance.isLogin) {
      return;
    }
    tryReconnect();
  }

  disconnect() async {
    needReConnect = false;
    cancelReconnect();
    _messageCallBack.clear();
    /// Closes the WebSocket connection. Set the optional [code] and [reason]
    /// arguments to send close information to the remote peer. If they are
    /// omitted, the peer will see [WebSocketStatus.noStatusReceived] code
    /// with no reason.
    try {
      await channel?.sink.close(status.goingAway);
    } on WebSocketChannelException catch (e) {
      LogUtil.e(message: 'WsManager-----$e');
    }
    channel = null;
    connectionStatus.value = ConnectionStatusEnum.closed;
    LogUtil.e(message: 'WsManager socket 通道关闭');
  }

  @override
  void onClose() {
    _messageCallBack.clear();
    _connectivitySubscription.cancel();
    disconnect();
  }

  Future<bool> sendMessage({
    required String message,
    required String receiverId,
    required String localId,
  }) async {
    if (connectionStatus.value != ConnectionStatusEnum.connected) {
      await connect();
    }
    Map messageData = _createTextMessageData(message, receiverId, localId);
    try {
      LogUtil.v(message: "WsManager send message:${json.encode(messageData).toString()}");

      channel?.sink.add(json.encode(messageData).toString());
      return Future(() => true);
    } on WebSocketChannelException catch (e) {
      LogUtil.e(message: 'WsManager-----$e');
      return Future(() => false);
    }
  }

  Future<bool> sendImage(
      {required String attachId,
        required String imageUrl,
        required String receiverId,
        required String localId}) async {
    if (connectionStatus.value != ConnectionStatusEnum.connected) {
      await connect();
    }
    Map imageData = _createImageData(attachId, imageUrl, receiverId, localId);

    try {
      channel?.sink.add(json.encode(imageData).toString());
      return Future(() => true);
    } on WebSocketChannelException catch (e) {
      LogUtil.e(message: 'WsManager-----$e');
      return Future(() => false);
    }
  }

  Future<bool> sendVoice({
    required String attachId,
    required String voiceUrl,
    required String receiverId,
    required String localId,
    required int duration,
  }) async {
    if (connectionStatus.value != ConnectionStatusEnum.connected) {
      await connect();
    }
    Map voiceData = _createVoiceData(attachId, voiceUrl, receiverId, localId, duration);
    try {
      channel?.sink.add(json.encode(voiceData).toString());
      return Future(() => true);
    } on WebSocketChannelException catch (e) {
      LogUtil.e(message: 'WsManager-----$e');
      return Future(() => false);
    }
  }

  sendSystemMsg({required Map messageMap}) async {
    if (connectionStatus.value != ConnectionStatusEnum.connected) {
      await connect();
    }
    LogUtil.v(message: "WsManager message:${json.encode(messageMap).toString()}");
    try {
      channel?.sink.add(json.encode(messageMap).toString());
    } on WebSocketChannelException catch (e) {
      LogUtil.e(message: 'WsManager-----$e');
    }
  }

  unSentMsg({required String fromId,required String toId,required String messageId,required int createTime,required String localId}){
    Map<String,dynamic> messageData =  _createUnsentData(fromId,toId,messageId,createTime,localId);
    sendSystemMsg(messageMap: messageData);
  }

  _createUnsentData(String fromId,String toId,String messageId,int createTime,String localId){
    Map<String,dynamic> messageData = {};
    messageData.putIfAbsent("type", () => MessageTypeEnum.RECALL.value);
    messageData.putIfAbsent("from_uid", () => fromId);
    messageData.putIfAbsent("to_uid", () => toId);
    messageData.putIfAbsent("type_id", () => MessageTypeIdEnum.MESSAGE_TYPE_RE_CALL.value);
    messageData.putIfAbsent("local_id", () => localId);
    messageData.putIfAbsent("content", () => StringRes.getString(StringRes.hintYouUnsentMsg));
    messageData.putIfAbsent("time", () => createTime);
    messageData.putIfAbsent("message_id", () => messageId);
    return messageData;
  }

  _createTextMessageData(String message, String receiverId, String localId) {
    Map<String, dynamic> messageData = {};
    messageData.putIfAbsent("type", () => MessageTypeEnum.SAY.value);
    messageData.putIfAbsent("to", () => receiverId);
    messageData.putIfAbsent("message", () => message);
    messageData.putIfAbsent("type_id", () => MessageTypeIdEnum.TEXT.value);
    messageData.putIfAbsent("local_id", () => localId);
    return messageData;
  }

  buildMarkReadData({required String messageId, required String receiverId}) {
    Map<String, dynamic> messageData = {};
    messageData.putIfAbsent("type", () => MessageTypeEnum.REPORT.value);
    messageData.putIfAbsent("to", () => receiverId);
    messageData.putIfAbsent("message_id", () => messageId);
    return messageData;
  }

  _createImageData(
      String attachId, String imageUrl, String receiverId, String localId) {
    Map<String, dynamic> messageData = {};
    messageData.putIfAbsent("type", () => MessageTypeEnum.SAY.value);
    messageData.putIfAbsent("to", () => receiverId);
    messageData.putIfAbsent("type_id", () => MessageTypeIdEnum.IMAGE.value);
    messageData.putIfAbsent("attach_id", () => attachId);
    messageData.putIfAbsent("url", () => imageUrl);
    messageData.putIfAbsent("local_id", () => localId);
    return messageData;
  }

  _createVoiceData(
      String attachId, String voiceUrl, String receiverId, String localId,int duration) {
    Map<String, dynamic> messageData = {};
    messageData.putIfAbsent("type", () => MessageTypeEnum.SAY.value);
    messageData.putIfAbsent("to", () => receiverId);
    messageData.putIfAbsent("type_id", () => MessageTypeIdEnum.VOICE.value);
    messageData.putIfAbsent("attach_id", () => attachId);
    messageData.putIfAbsent("url", () => voiceUrl);
    messageData.putIfAbsent("local_id", () => localId);
    messageData.putIfAbsent("duration", ()=> duration);
    return messageData;
  }

  void buildConnect() async {
    if (connectionStatus.value != ConnectionStatusEnum.connected) {
      await connect();
    }

  }

  get logInFirstDialogWidget =>  CustomDialog(noticeContent: 'Please login first!',confirmTap: (){
    AppService.instance.forceLogout(isDelete: true);
  },);
}
