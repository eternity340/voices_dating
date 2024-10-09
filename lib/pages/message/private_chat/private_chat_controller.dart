import 'package:voices_dating/entity/user_data_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:voices_dating/entity/chatted_user_entity.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';
import '../../../components/bottom_options.dart';
import '../../../components/custom_message_dialog.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/im_message_entity.dart';
import '../../../entity/im_new_message_emtity.dart';
import '../../../entity/ret_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../net/dio.client.dart';
import 'package:voices_dating/net/api_constants.dart';
import '../../../routes/app_routes.dart';
import '../../../service/audio_service.dart';
import '../../../service/global_service.dart';
import '../../../service/im_service.dart';
import '../../../utils/log_util.dart';
import '../../../components/photo_dialog.dart';
import '../../home/user_profile/user_profile_page.dart';

class PrivateChatController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
  final UserDataEntity userDataEntity = Get.arguments['userDataEntity'] as UserDataEntity;
  final ChattedUserEntity chattedUser = Get.arguments['chattedUser'] as ChattedUserEntity;
  var messages = <IMNewMessageEntity>[].obs;
  final ScrollController scrollController = ScrollController();
  final GlobalService globalService = Get.find<GlobalService>();
  final TextEditingController textController = TextEditingController();
  Sender? currentUserSender;
  Sender? currentChatSender;
  RxBool isRecording = false.obs;
  int currentPage = 1;
  static const int pageSize = 20;
  final AudioService audioService = AudioService();

  @override
  void onInit() {
    super.onInit();
    getHistoryMessages();
    _subscribeToIMMessages();
    _initAudioRecorder();
    currentUserSender = Sender(
      profile: Profile(
        userId: userDataEntity.userId,
        username: userDataEntity.username,
        avatarUrl: userDataEntity.avatar,
      ),
    );
  }

  Future<void> _initAudioRecorder() async {
    await audioService.initRecorder();
  }

  Future<void> startRecording() async {
    await audioService.startRecording();
    isRecording.value = true;
  }

  Future<void> stopRecording() async {
    final recordingPath = await audioService.stopRecording();
    isRecording.value = false;
    if (recordingPath != null) {
      final duration = await audioService.getAudioDuration(recordingPath);
      sendVoiceMessage(recordingPath, duration);
    }
  }

  Future<int> _getAudioDuration(String path) async {
    final player = AudioPlayer();
    final duration = await player.setFilePath(path);
    await player.dispose();
    return duration?.inSeconds ?? 0;
  }

  void sendVoiceMessage(String filePath, int duration) async {
    var localId = const Uuid().v4().toString();
    String audioUrl = await uploadAudioFile(filePath);

    var sendSuccess = IMService.instance.sendVoice(
      voiceUrl: audioUrl,
      duration: duration,
      receiverId: chattedUser.userId!,
      localId: localId,
      attachId: '',
    );

    if (await sendSuccess) {
      final newMessage = IMNewMessageEntity(
        localId: localId,
        message: 'Voice message',
        url: audioUrl,
        duration: duration.toString(),
        messageType: 3,
        created: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        profId: currentUserSender?.profile?.userId,
        sender: currentUserSender,
      );
      messages.add(newMessage);
      scrollToBottom();
    }
  }

  Future<String> uploadAudioFile(String filePath) async {
    return 'https://example.com/audio.aac';
  }

  void _subscribeToIMMessages() {
    IMService.instance.addMessageCallBack(_handleNewMessage);
  }

  void _handleNewMessage(IMMessageEntity message) {
    if (message.type != MessageTypeEnum.SAY.value ||
        (message.fromUid != chattedUser.userId &&
         message.toUid != chattedUser.userId)) {
      return;
    }

    final bool isImageMessage = message.typeId == 2;
    final bool isVoiceMessage = message.typeId == 3;
    final IMNewMessageEntity newMessage = IMNewMessageEntity(
      localId: message.localId ?? '',
      message: message.content ?? '',
      url: isImageMessage || isVoiceMessage ? message.url : null,
      roomId: isImageMessage ? message.roomId : null,
      duration: isVoiceMessage ? message.duration.toString() : null,
      width: isImageMessage ? message.width : null,
      height: isImageMessage ? message.height : null,
      messageType: message.typeId,
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

  Future<void> getHistoryMessages({int page = 1, bool isLoadMore = false}) async {
    DioClient.instance.requestNetwork<List<IMNewMessageEntity>>(
      method: Method.get,
      url: ApiConstants.historyMessages,
      queryParameters: {
        'profId': chattedUser.userId,
        'page': page,
        'offset': pageSize
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
            } else {
              currentChatSender = message.sender;
            }
            return message;
          }).toList();

          if (isLoadMore) {
            messages.insertAll(0, mappedData.reversed);
          } else {
            messages.value = mappedData.reversed.toList();
            scrollToBottom();
          }
        }
      },
      onError: (int code, String msg, dynamic data) {
        LogUtil.e(message: "get HistoryMessageError${msg.toString()}");
      },
    );
  }

  Future<void> loadMoreMessages() async {
    currentPage++;
    await getHistoryMessages(page: currentPage, isLoadMore: true);
  }

  void sendTextMessage() {
    String text = textController.text.trim();
    if (text.isEmpty) {
      return;
    }
    var localId = const Uuid().v4().toString();
    var sendSuccess = IMService.instance.sendMessage(
        message: text,
        receiverId: chattedUser.userId!,
        localId: localId);
    LogUtil.d(message: 'WsManager sendSuccess text:$sendSuccess');
    textController.clear();
    scrollToBottom();
  }

  String formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('MM-dd hh:mm a').format(dateTime);
  }

  bool shouldShowTimeDivider(int currentTimestamp, int previousTimestamp) {
    return (currentTimestamp - previousTimestamp) > (600);
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

  void showPhotoDialog(BuildContext context, String photoUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PhotoDialog(
          photoUrl: photoUrl,
          attachId: '',
          onDelete: null,
          onSetting: null,
          showSettings: false,
        );
      },
    );
  }

  void onAvatarTap(String userId) async {
    final GlobalService globalService = Get.find<GlobalService>();
    final UserDataEntity? userDataEntity = await globalService.getUserProfile(
      userId: userId,
    );
    if (userDataEntity != null) {
      Get.toNamed(AppRoutes.messageUserProfile, arguments: {
        'userDataEntity': userDataEntity,
        'tokenEntity': tokenEntity,
      });
    } else {
      LogUtil.e(message: 'Failed to get user profile');
      Get.snackbar('Error', 'Failed to load user profile');
    }
  }

  void showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomOptions(
          onFirstPressed: () {
            Navigator.pop(context);
            Get.toNamed(AppRoutes.messageUserReport, arguments: {
              'userDataEntity': userDataEntity,
              'tokenEntity': tokenEntity,
            });
          },
          onSecondPressed: () {
            Navigator.pop(context);
            showBlockUserDialog(context);
          },
          onCancelPressed: () => Navigator.pop(context),
          firstText: ConstantData.reportButton,
          secondText: ConstantData.blockButton,
        );
      },
    );
  }

  void showBlockUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomMessageDialog(
          title: const Text(ConstantData.blockUserText),
          content: const Text(ConstantData.blockUserDialogText),
          onYesPressed:blockUser,
        );
      },
    );
  }

  void blockUser() {
    DioClient.instance.requestNetwork<RetEntity>(
      method: Method.post,
      url: ApiConstants.blockUser,
      queryParameters: {'userId': chattedUser.userId},
      options: Options(headers: {'token': tokenEntity.accessToken}),
      onSuccess: (data) {
        if (data != null && data.ret) {
          Get.back();
          Get.snackbar(ConstantData.successText, ConstantData.userHasBlocked);
        } else {
          Get.snackbar(ConstantData.failedText, ConstantData.failedBlocked);
        }
      },
      onError: (code, msg, data) {
        Get.snackbar(ConstantData.errorText, msg);
      },
    );
  }

  @override
  void onClose() {
    audioService.dispose();
    super.onClose();
  }
}