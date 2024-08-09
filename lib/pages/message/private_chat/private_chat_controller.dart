import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:first_app/entity/chatted_user_entity.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
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

  @override
  void onInit() {
    super.onInit();
    fetchHistoryMessages();
  }

  void fetchHistoryMessages() async {
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
          messages.value = data.reversed.toList();
          _scrollToBottom();
        }
      },
      onError: (int code, String msg, dynamic data) {
        // Handle error here
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
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
    var sendSuccess =  IMService.instance.sendMessage(message: text, receiverId: chattedUser.userId!, localId: localId);
    LogUtil.d(message: 'WsManager sendSuccess text:$sendSuccess');
  }

  String formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('MM-dd hh:mm a').format(dateTime);
  }

  bool shouldShowTimeDivider(int currentTimestamp, int previousTimestamp) {
    return (currentTimestamp - previousTimestamp) > (10 * 60);  // 5 minutes in seconds
  }
}
