import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../entity/chatted_user_entity.dart';
import '../../../entity/im_message_entity.dart';
import '../../net/dio.client.dart';
import '../../../utils/log_util.dart';
import '../../net/api_constants.dart';
import '../../service/im_service.dart';

class MessageController extends GetxController {
  final TokenEntity tokenEntity;
  final UserDataEntity userDataEntity;
  int selectedIndex = 0;
  List<ChattedUserEntity> chattedUsers = [];
  late PageController pageController;

  MessageController(this.tokenEntity, this.userDataEntity) {
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void onInit() {
    super.onInit();
    fetchChattedUsers();
    connectWebSocket();
  }

  void connectWebSocket() {
    IMService.instance.connect();
    IMService.instance.addMessageCallBack(_handleWebSocketMessage);
  }

  void _handleWebSocketMessage(IMMessageEntity messageEntity) {
    if (messageEntity.type == MessageTypeEnum.SAY.value) {
      _updateChattedUsers(messageEntity);
    }
  }

  void _updateChattedUsers(IMMessageEntity messageEntity) {
    if (messageEntity.fromUid == userDataEntity.userId) {
      return;
    }
    int index = chattedUsers.indexWhere((user) => user.userId == messageEntity.fromUid);
    if (index != -1) {
      ChattedUserEntity user = chattedUsers.removeAt(index);
      user.lastmessage = messageEntity.content;
      user.created = messageEntity.time;
      user.newNumber = (user.newNumber != null) ? (int.parse(user.newNumber!) + 1).toString() : '1';
      chattedUsers.insert(0, user);
    } else {
      ChattedUserEntity newUser = ChattedUserEntity(
        userId: messageEntity.fromUid,
        username: messageEntity.fromName,
        avatar: '',
        lastmessage: messageEntity.content,
        created: messageEntity.time,
      );
      chattedUsers.insert(0, newUser);
    }
    update();
  }

  void changeSelectedIndex(int index) {
    selectedIndex = index;
    // Ensure the jumpToPage is called after the frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        pageController.jumpToPage(index);
      }
    });
    update();
  }

  @override
  void dispose() {
    pageController.dispose();
    IMService.instance.removeMessageCallBack(_handleWebSocketMessage);
    IMService.instance.disconnect();
    super.dispose();
  }

  Future<void> fetchChattedUsers() async {
    try {
      DioClient dioClient = DioClient();
      dioClient.init(options: BaseOptions(
        headers: {
          'token': tokenEntity.accessToken,
        },
      ));
      dioClient.requestNetwork<List<ChattedUserEntity>>(
        method: Method.get,
        url: ApiConstants.chattedUsers,
        onSuccess: (data) {
          chattedUsers = data!;
          update();
        },
        onError: (code, msg, data) {
          LogUtil.e(message: 'Fetch error: $msg');
        },
      );
    } catch (e) {
      LogUtil.e(message: 'Fetch error: $e');
    }
  }

  void clearNewNumber(String userId) {
    int index = chattedUsers.indexWhere((user) => user.userId == userId);
    if (index != -1) {
      chattedUsers[index].newNumber = '0';
      update();
    }
  }
}