import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:voices_dating/pages/me/my_profile/update_profile/upload_voice/record/record_page.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../../entity/ret_entity.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import '../../../../../entity/user_voice_entity.dart';
import '../../../../../net/dio.client.dart';
import '../../../../../service/audio_service.dart';
import '../../../../../service/global_service.dart';
import '../../my_profile_page.dart';

class UploadVoiceController extends GetxController {
  final TokenEntity tokenEntity;
  late  UserDataEntity userData;
  String? recordFilePath;
  RxInt selectedIndex = RxInt(-1);
  late AudioPlayer audioPlayer;
  RxBool isPlaying = false.obs;
  RxBool hasAudio = false.obs;
  RxList<String> audioList = <String>[].obs;
  final GlobalService globalService = Get.find<GlobalService>();
  final AudioService audioService = AudioService.instance;
  final DioClient dioClient = DioClient.instance;

  UploadVoiceController(this.tokenEntity, this.userData, this.recordFilePath);

  @override
  void onInit() {
    super.onInit();
    _initAudioList();
    _initAudioPlayer();
  }

  bool get isButtonEnabled {
    if (selectedIndex.value == -1 || audioList.isEmpty) return false;
    if (selectedIndex.value >= audioList.length) return false;
    if (userData.voice != null && userData.voice!.voiceUrl != null) {
      return audioList[selectedIndex.value] != userData.voice!.voiceUrl;
    }
    return true;
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

  Future<void> saveSelectedVoice() async {
    if (selectedIndex.value == -1 || audioList.isEmpty) {
      return;
    }

    String selectedAudioPath = audioList[selectedIndex.value];
    String? attachId = await globalService.uploadFile(
        selectedAudioPath,
        tokenEntity.accessToken.toString());
    if (attachId == null) {
      return;
    }
    int duration = await audioService.getAudioDuration(selectedAudioPath);

    try {
      await dioClient.requestNetwork<UserVoiceEntity>(
        method: Method.post,
        url: ApiConstants.uploadVoice,
        options: Options(headers: {'token': tokenEntity.accessToken}),
        params: {
          'attachId': attachId,
          'duration': duration,
          'description': 'voiceMessage',
        },
        onSuccess: (data) async {
          if (data != null) {
            await globalService.refreshUserData(tokenEntity.accessToken.toString());
            userData = globalService.userDataEntity.value!;

            // 删除本地录音文件并清除 recordFilePath
            if (recordFilePath != null) {
              if (File(recordFilePath!).existsSync()) {
                File(recordFilePath!).deleteSync();
              }
              int recordIndex = audioList.indexOf(recordFilePath!);
              if (recordIndex != -1) {
                audioList.removeAt(recordIndex);
              }
              // 清除 recordFilePath
              recordFilePath = null;
            }

            // 更新音频列表
            audioList.clear();
            _initAudioList();
            selectedIndex.value = -1; // 重置选中状态
            update();
            Get.snackbar('Success', 'Voice saved successfully');
            navigateToMeMyProfilePage();
          }
        },
        onError: (int code, String msg, UserVoiceEntity? data) {
          LogUtil.e(msg);
          Get.snackbar('Error', 'Failed to save voice: $msg');
        },
      );
    } catch (e) {
      LogUtil.e(e.toString());
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }


  Future<void> deleteUserVoice() async {
    if (userData.voice == null || userData.voice!.attachId == null) {
      Get.snackbar('Error', 'No voice to delete');
      return;
    }

    try {
      await dioClient.requestNetwork<RetEntity>(
        method: Method.post,
        url: ApiConstants.deleteVoice,
        options: Options(headers: {'token': tokenEntity.accessToken}),
        params: {
          'attachId': userData.voice!.attachId,
        },
        onSuccess: (data) async {
          if (data!.ret == true) {
            await globalService.refreshUserData(tokenEntity.accessToken.toString());
            userData = globalService.userDataEntity.value!;
            audioList.clear();
            _initAudioList();

            selectedIndex.value = -1;
            update();
            Get.snackbar('Success', 'Voice deleted successfully');
          } else {
            Get.snackbar('Error', 'Failed to delete voice');
          }
        },
        onError: (int code, String msg, RetEntity? data) {
          LogUtil.e(msg);
          Get.snackbar('Error', 'Failed to delete voice: $msg');
        },
      );
    } catch (e) {
      LogUtil.e(e.toString());
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }

  // 修改 deleteAudio 方法
  Future<void> deleteAudio(int index) async {
    if (audioList[index] == userData.voice?.voiceUrl) {
      await deleteUserVoice();
    } else {
      audioList.removeAt(index);
      if (selectedIndex.value == index) {
        selectedIndex.value = -1;
      } else if (selectedIndex.value > index) {
        selectedIndex.value--;
      }
      hasAudio.value = audioList.isNotEmpty;
      update();
    }
  }

  /*void deleteAudio(int index) {
    String removedItem = audioList.removeAt(index);
    if (selectedIndex.value == index) {
      selectedIndex.value = -1;
    } else if (selectedIndex.value > index) {
      selectedIndex.value--;
    }
    hasAudio.value = audioList.isNotEmpty;
    update();
  }*/

  Future<void> playPause() async {
    if (!hasAudio.value) return;

    if (isPlaying.value) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
    isPlaying.toggle();
  }

  Future<void> handleSave(BuildContext context) async {
    if (selectedIndex.value != -1) {
      await saveSelectedVoice();
    } else {
      Get.snackbar('Warning', 'Please select a voice to save');
    }
  }

  void navigateToRecordPage() {
    Get.toNamed(AppRoutes.meMyProfileRecord, arguments: {
      'tokenEntity': tokenEntity,
      'userDataEntity': userData,
    });
  }

  void navigateToMeMyProfilePage() {
    Get.to(() => MyProfilePage(), arguments: {
      'tokenEntity': tokenEntity,
      'userDataEntity': userData,
    });
  }

  @override
  void onClose() {
    if (recordFilePath != null && File(recordFilePath!).existsSync()) {
      File(recordFilePath!).deleteSync();
    }
    Get.delete<UploadVoiceController>();
    audioPlayer.dispose();
    super.onClose();
  }
}
