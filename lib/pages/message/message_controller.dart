  import 'package:flutter/cupertino.dart';
  import 'package:get/get.dart';
  import 'package:dio/dio.dart';
  import '../../../entity/token_entity.dart';
  import '../../../entity/user_data_entity.dart';
  import '../../../entity/chatted_user_entity.dart';
  import '../../../entity/im_message_entity.dart';
  import '../../entity/list_user_entity.dart';
  import '../../net/dio.client.dart';
  import '../../../utils/log_util.dart';
  import '../../net/api_constants.dart';
  import '../../service/im_service.dart';
import '../../utils/replace_word_util.dart';

  class MessageController extends GetxController {
    final TokenEntity tokenEntity;
    final UserDataEntity userDataEntity;
    int selectedIndex = 0;
    List<ChattedUserEntity> chattedUsers = [];
    late PageController pageController;
    bool _disposed = false;
    final RxList<ListUserEntity> visitedMeUsers = <ListUserEntity>[].obs;
    final RxList<ListUserEntity> likedMeUsers = <ListUserEntity>[].obs;
    final ReplaceWordUtil replaceWordUtil = ReplaceWordUtil.getInstance();
    final DioClient dioClient = DioClient.instance;

    MessageController(this.tokenEntity, this.userDataEntity) {
      pageController = PageController(initialPage: selectedIndex);
    }

    @override
    void onInit() {
      super.onInit();
      fetchChattedUsers();
      getViewedMeUsers();
      getLikedMeUsers();
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
      safeUpdate();
    }

    void changeSelectedIndex(int index) {
      if (_disposed) return;
      selectedIndex = index;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_disposed && pageController.hasClients) {
          pageController.jumpToPage(index);
        }
      });
      safeUpdate();
    }

    Future<void> fetchChattedUsers() async {
      try {
        await dioClient.requestNetwork<List<dynamic>>(
          method: Method.get,
          url: ApiConstants.chattedUsers,
          options: Options(
            headers: {
              'token': tokenEntity.accessToken,
            },
          ),
          onSuccess: (data) {
            if (data != null) {
              chattedUsers = data.map((user) {
                var processedUser = replaceWordUtil.replaceWordsInJson(user);
                return ChattedUserEntity.fromJson(processedUser);
              }).toList();
              update();
            }
          },
          onError: (code, msg, data) {
            LogUtil.e(message: msg);
          },
        );
      } catch (e) {
        LogUtil.e(message: e.toString());
      }
    }

    Future<void> getViewedMeUsers() async {
      try {
        await dioClient.requestNetwork<List<dynamic>>(
          method: Method.get,
          url: ApiConstants.visiteMeUsers,
          options: Options(
            headers: {
              'token': tokenEntity.accessToken,
            },
          ),
          onSuccess: (data) {
            if (data != null) {
              visitedMeUsers.value = data.map((json) {
                var processedJson = replaceWordUtil.replaceWordsInJson(json);
                return ListUserEntity.fromJson(processedJson);
              }).toList();
              update();
            }
          },
          onError: (code, msg, data) {
            LogUtil.e(message: msg);
          },
        );
      } catch (e) {
        LogUtil.e(message: e.toString());
      }
    }

    Future<void> getLikedMeUsers() async {
      try {
        await dioClient.requestNetwork<List<dynamic>>(
          method: Method.get,
          url: ApiConstants.likeMeUser,
          options: Options(
            headers: {
              'token': tokenEntity.accessToken,
            },
          ),
          onSuccess: (data) {
            if (data != null) {
              likedMeUsers.value = data.map((json) {
                var processedJson = replaceWordUtil.replaceWordsInJson(json);
                return ListUserEntity.fromJson(processedJson);
              }).toList();
              update();
            }
          },
          onError: (code, msg, data) {
            LogUtil.e(message: msg);
          },
        );
      } catch (e) {
        LogUtil.e(message: e.toString());
      }
    }

    void clearNewNumber(String userId) {
      int index = chattedUsers.indexWhere((user) => user.userId == userId);
      if (index != -1) {
        chattedUsers[index].newNumber = '0';
        update();
      }
    }

    void safeUpdate() {
      if (!_disposed) {
        update();
      }
    }

    @override
    void onClose() {
      _disposed = true;
      pageController.dispose();
      IMService.instance.removeMessageCallBack(_handleWebSocketMessage);
      IMService.instance.disconnect();
      super.onClose();
    }
  }
