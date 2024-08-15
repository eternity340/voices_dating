import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:first_app/entity/chatted_user_entity.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../entity/im_message_entity.dart';
import '../../../entity/im_new_message_emtity.dart';
import '../../../entity/token_entity.dart';
import '../../../net/dio.client.dart';
import 'package:first_app/net/api_constants.dart';

import '../../../service/im_service.dart';
import '../../../utils/log_util.dart';
import '../../../components/photo_dialog.dart';

class PrivateChatController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments['token'] as TokenEntity;
  final ChattedUserEntity chattedUser =
  Get.arguments['chattedUser'] as ChattedUserEntity;
  var messages = <IMNewMessageEntity>[].obs;
  final ScrollController scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();
  Sender? currentUserSender;
  Sender? currentChatSender;
  FlutterSoundRecorder? _audioRecorder;
  String? _recordingPath;
  RxBool isRecording = false.obs;


  @override
  void onInit() {
    super.onInit();
    getHistoryMessages();
    _subscribeToIMMessages();
    _initAudioRecorder();
  }

  Future<void> _initAudioRecorder() async {
    _audioRecorder = FlutterSoundRecorder();
    await _audioRecorder!.openRecorder();
  }

  Future<void> startRecording() async {
    if (_audioRecorder != null) {
      final directory = await getTemporaryDirectory();
      _recordingPath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _audioRecorder!.startRecorder(toFile: _recordingPath);
      isRecording.value = true;
    }
  }

  Future<void> stopRecording() async {
    if (_audioRecorder != null) {
      await _audioRecorder!.stopRecorder();
      isRecording.value = false;
      if (_recordingPath != null) {
        final duration = await _getAudioDuration(_recordingPath!);
        sendVoiceMessage(_recordingPath!, duration);
      }
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
    // 这里需要实现上传音频文件到服务器的逻辑，并获取URL
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
        messageType: 3, // 语音消息类型
        created: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        profId: currentUserSender?.profile?.userId,
        sender: currentUserSender,
      );
      messages.add(newMessage);
      scrollToBottom();
    }
  }

  Future<String> uploadAudioFile(String filePath) async {
    // 实现文件上传逻辑，返回服务器URL
    // 这里需要根据您的后端API来实现
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
            }else{
              currentChatSender = message.sender;
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
}