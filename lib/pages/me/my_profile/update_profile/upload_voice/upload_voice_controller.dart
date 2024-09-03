import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:first_app/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import '../../../../../service/audio_service.dart';
import '../../../../../service/global_service.dart';

class UploadVoiceController extends GetxController {
  final TokenEntity tokenEntity;
  final UserDataEntity userData;
  final String? recordFilePath;
  RxInt selectedIndex = RxInt(-1);
  late AudioPlayer audioPlayer;
  RxBool isPlaying = false.obs;
  RxBool hasAudio = false.obs;
  RxList<String> audioList = <String>[].obs;
  final GlobalService globalService = Get.find<GlobalService>();
  final AudioService audioService = AudioService.instance;

  UploadVoiceController(this.tokenEntity, this.userData, this.recordFilePath);

  @override
  void onInit() {
    super.onInit();
    _initAudioList();
    _initAudioPlayer();
  }

  void _initAudioList() {
    if (userData.voice != null && userData.voice!.voiceUrl != null) {
      audioList.add(userData.voice!.voiceUrl!);
      hasAudio.value = true;
    }

    if (recordFilePath != null) {
      audioList.add(recordFilePath!);
      hasAudio.value = true;
    }
  }

  Future<void> _initAudioPlayer() async {
    audioPlayer = AudioPlayer();
    if (audioList.isNotEmpty) {
      await audioPlayer.setFilePath(audioList.first);
      hasAudio.value = true;
    }
  }

  void toggleSelection(int index) {
    if (selectedIndex.value == index) {
      selectedIndex.value = -1;
    } else {
      selectedIndex.value = index;
    }
    update();
  }

  Future<bool> saveSelectedVoice() async {
    if (selectedIndex.value == -1 || audioList.isEmpty) {
      return false;
    }

    String selectedAudioPath = audioList[selectedIndex.value];
    String? attachId = await globalService.uploadFile(
        selectedAudioPath,
        tokenEntity.accessToken.toString());

    if (attachId == null) {
      return false;
    }

    int duration = await audioService.getAudioDuration(selectedAudioPath);

    try {
      final response = await Dio().post(
        ApiConstants.uploadVoice,
        options: Options(headers: {'token': tokenEntity.accessToken}),
        queryParameters: {
          'attachId': attachId,
          'duration': duration,
          'description': 'voiceMessage',
        },
      );

      if (response.data['code'] == 200) {
        await globalService.refreshUserData(tokenEntity.accessToken.toString());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      LogUtil.e(e.toString());
      return false;
    }
  }

  void deleteAudio(int index) {
    String removedItem = audioList.removeAt(index);
    if (selectedIndex.value == index) {
      selectedIndex.value = -1;
    } else if (selectedIndex.value > index) {
      selectedIndex.value--;
    }
    hasAudio.value = audioList.isNotEmpty;
    update();
  }

  Future<void> playPause() async {
    if (!hasAudio.value) return;

    if (isPlaying.value) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
    isPlaying.toggle();
  }

  void navigateToMyProfile() {
    Get.offAllNamed(AppRoutes.meMyProfile, arguments: {
      'token': tokenEntity,
      'userData': globalService.userDataEntity.value,
    });
  }

  @override
  void onClose() {
    Get.delete<UploadVoiceController>();
    audioPlayer.dispose();
    super.onClose();
  }
}
