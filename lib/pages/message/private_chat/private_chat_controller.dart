import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:first_app/entity/chatted_user_entity.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../entity/im_message_entity.dart';
import '../../../entity/im_new_message_emtity.dart';
import '../../../entity/token_entity.dart';
import '../../../net/dio.client.dart';
import 'package:first_app/net/api_constants.dart';

import '../../../service/im_service.dart';
import '../../../utils/log_util.dart';

class PrivateChatController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments['token'] as TokenEntity;
  final ChattedUserEntity chattedUser = Get.arguments['chattedUser'] as ChattedUserEntity;
  var messages = <IMNewMessageEntity>[].obs;
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  Sender? currentUserSender;

  @override
  void onInit() {
    super.onInit();
    getHistoryMessages();
    _subscribeToIMMessages();
  }

  void _subscribeToIMMessages() {
    IMService.instance.addMessageCallBack(_handleNewMessage);
  }

  void _handleNewMessage(IMMessageEntity message) {
    if (message.type == MessageTypeEnum.SAY.value &&
        (message.fromUid == chattedUser.userId || message.toUid == chattedUser.userId)) {
      final newMessage = IMNewMessageEntity(
        localId: message.localId ?? '',
        message: message.content ?? '',
        created: message.time ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
        profId: message.fromUid,
        sender: Sender(
          profile: Profile(
            userId: message.fromUid ?? '',
            avatarUrl: message.fromUid == chattedUser.userId
                ? chattedUser.avatar
                : currentUserSender?.profile?.avatarUrl ?? '',
          ),
        ),
      );
      messages.add(newMessage);
      scrollToBottom();
    }
  }

  void getHistoryMessages() async {
    DioClient.instance.requestNetwork<List<IMNewMessageEntity>>(
      method: Method.get,
      url: ApiConstants.historyMessages,
      queryParameters: {
        'profId': chattedUser.userId,
      },
      options: Options(
        headers: {
          'token': tokenEntity.accessToken,
        },
      ),
      onSuccess: (List<IMNewMessageEntity>? data) {
        if (data != null) {
          final mappedData = data.map((message) {
            message.profId = message.sender?.profile?.userId;
            if (message.profId != chattedUser.userId) {
              currentUserSender = message.sender;
            }
            return message;
          }).toList();
          messages.value = mappedData.reversed.toList();
          scrollToBottom();
        }
      },
      onError: (int code, String msg, dynamic data) {
        LogUtil.e(message: "get HistoryMessageError${msg.toString()}");
      },
    );
  }

  void sendTextMessage() {
    /*if(chattedUser.canChat!=1){
      Get.toNamed('/me/settings/purchase_record', arguments: {'token': tokenEntity});
      return;
    }*/
    String text = messageController.text.trim();
    if (text.isEmpty) {
      return;
    }
    var localId = const Uuid().v4().toString();
   /* var now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var newMessage = IMNewMessageEntity(
      localId: localId,
      message: text,
      created: now,
      profId: currentUserSender?.profile?.userId,
      sender: currentUserSender,
    );
    messages.add(newMessage); // 改为 add 而不是 insert
    print('New message added: ${newMessage.message}');*/
    var sendSuccess = IMService.instance.sendMessage(
        message: text,
        receiverId: chattedUser.userId!,
        localId: localId);
    LogUtil.d(message: 'WsManager sendSuccess text:$sendSuccess');
    messageController.clear();
    scrollToBottom();
  }

  String formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('MM-dd hh:mm a').format(dateTime);
  }

  bool shouldShowTimeDivider(int currentTimestamp, int previousTimestamp) {
    return (currentTimestamp - previousTimestamp) > (10 * 60);  // 5 minutes in seconds
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
