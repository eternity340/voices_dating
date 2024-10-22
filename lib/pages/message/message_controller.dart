import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:voices_dating/constants/constant_data.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../entity/chatted_user_entity.dart';
import '../../../entity/im_message_entity.dart';
import '../../components/custom_message_dialog.dart';
import '../../entity/list_user_entity.dart';
import '../../entity/ret_entity.dart';
import '../../net/dio.client.dart';
import '../../../utils/log_util.dart';
import '../../net/api_constants.dart';
import '../../service/global_service.dart';
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

  int chatPage = 1;
  final int chatOffset = 10;

  int viewedMePage = 1;
  final int viewedMeOffset = 10;

  int likeMePage = 1;
  final int likeMeOffset = 10;

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

  void _updateChattedUsers(IMMessageEntity messageEntity) async {
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
      UserDataEntity? userData = await GlobalService.to.getUserProfile(userId: messageEntity.fromUid.toString());
      ChattedUserEntity newUser = ChattedUserEntity(
          userId: messageEntity.fromUid,
          username: messageEntity.fromName,
          avatar: userData?.avatar ?? '',
          lastmessage: messageEntity.content,
          created: messageEntity.time,
          newNumber: "1"
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
  Future<void> fetchChattedUsers({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      chatPage = 1;
    }
    try {
      await dioClient.requestNetwork<List<dynamic>>(
        method: Method.get,
        url: ApiConstants.chattedUsers,
        queryParameters: {
          'page': chatPage,
          'offset': chatOffset,
        },
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
        onSuccess: (data) {
          if (data != null) {
            List<ChattedUserEntity> newUsers = data.map((user) {
              var processedUser = replaceWordUtil.replaceWordsInJson(user);
              return ChattedUserEntity.fromJson(processedUser);
            }).toList();

            if (isLoadMore) {
              chattedUsers.addAll(newUsers);
            } else {
              chattedUsers = newUsers;
            }
            chatPage++;
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

  Future<void> getViewedMeUsers({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      viewedMePage = 1;
    }
    try {
      await dioClient.requestNetwork<List<dynamic>>(
        method: Method.get,
        url: ApiConstants.visiteMeUsers,
        queryParameters: {
          'page': viewedMePage,
          'offset': viewedMeOffset,
        },
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
        onSuccess: (data) {
          if (data != null) {
            List<ListUserEntity> newUsers = data.map((json) {
              var processedJson = replaceWordUtil.replaceWordsInJson(json);
              return ListUserEntity.fromJson(processedJson);
            }).toList();

            if (isLoadMore) {
              visitedMeUsers.addAll(newUsers);
            } else {
              visitedMeUsers.value = newUsers;
            }
            viewedMePage++;
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

  Future<void> getLikedMeUsers({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      likeMePage = 1;
    }
    try {
      await dioClient.requestNetwork<List<dynamic>>(
        method: Method.get,
        url: ApiConstants.likeMeUser,
        queryParameters: {
          'page': likeMePage,
          'offset': likeMeOffset,
        },
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
        onSuccess: (data) {
          if (data != null) {
            List<ListUserEntity> newUsers = data.map((json) {
              var processedJson = replaceWordUtil.replaceWordsInJson(json);
              return ListUserEntity.fromJson(processedJson);
            }).toList();

            if (isLoadMore) {
              likedMeUsers.addAll(newUsers);
            } else {
              likedMeUsers.value = newUsers;
            }
            likeMePage++;
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

  Future<void> onLoadChat() async {
    await fetchChattedUsers(isLoadMore: true);
  }

  Future<void> onLoadViewedMe() async {
    await getViewedMeUsers(isLoadMore: true);
  }

  Future<void> onLoadLikedMe() async {
    await getLikedMeUsers(isLoadMore: true);
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

  Future<void> deleteChat(ChattedUserEntity user) async {
    final completer = Completer<bool>();
    await Get.dialog(
      CustomMessageDialog(
        title: Text(ConstantData.deleteConversationTitle),
        content: Text(ConstantData.deleteConversationContent),
        onYesPressed: () {
          completer.complete(true);
          },
      ),
      barrierDismissible: false,
    );

    if (!completer.isCompleted) {
      completer.complete(false);
    }

    bool shouldDelete = await completer.future;

    if (shouldDelete) {
      try {
        await dioClient.requestNetwork<RetEntity>(
          url: ApiConstants.deleteConversation,
          method: Method.post,
          queryParameters: {
            'profId': user.userId,
            'status': 1,
          },
          options: Options(
            headers: {
              'token': tokenEntity.accessToken,
            },
          ),
          onSuccess: (data) {
            chattedUsers.remove(user);
            sendReadMessageRequest(user);
            update();
            },
          onError: (code, msg, data) {
            LogUtil.e(message: '$msg,$data');
            Get.snackbar(ConstantData.failedText, msg);
            },
          );
      } catch (e) {
        LogUtil.e(message: e.toString());
        Get.snackbar(ConstantData.failedText, e.toString());
      }
    }
  }

  void navigateToPrivateChat(ChattedUserEntity user) {
    Get.toNamed('/message/private_chat', arguments: {
      'tokenEntity': tokenEntity,
      'chattedUser': user,
      'userDataEntity': userDataEntity
    })?.then((_) {
      clearNewNumber(user.userId.toString());
    });
  }

  void sendReadMessageRequest(ChattedUserEntity user) {
    dioClient.requestNetwork(
      url: ApiConstants.readMessage,
      queryParameters: {
        'profId': user.userId,
      },
      options: Options(
        headers: {
          'token': tokenEntity.accessToken,
        },
      ),
      onSuccess: (data) {
        print('Request successful');
        },
      onError: (code, msg, data) {
        print('Request failed: $msg');
        },
      );
    }

  String formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final formatter = DateFormat('hh:mm a');
    return formatter.format(date);
  }

  @override
  void onClose() {
    _disposed = true;
    pageController.dispose();
    IMService.instance.removeMessageCallBack(_handleWebSocketMessage);
    //IMService.instance.disconnect();
    super.onClose();
  }
}