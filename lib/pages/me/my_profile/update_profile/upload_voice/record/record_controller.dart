import 'dart:async';
import 'package:voices_dating/pages/me/my_profile/update_profile/upload_voice/upload_voice_page.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:get/get.dart';
import '../../../../../../entity/token_entity.dart';
import '../../../../../../entity/user_data_entity.dart';
import '../../../../../../service/audio_service.dart';
import '../../../../../../service/global_service.dart';
import '../upload_voice_controller.dart';


class RecordController extends GetxController {
  final TokenEntity tokenEntity;
  final UserDataEntity userData;
  final AudioService audioService = AudioService();
  final GlobalService globalService = Get.find<GlobalService>();

  int _seconds = 0;
  Timer? _timer;
  bool _isRecording = false;
  String? recordFilePath;

  RecordController(this.tokenEntity, this.userData);

  int get seconds => _seconds;
  bool get isRecording => _isRecording;

  String get timerText {
    int minutes = _seconds ~/ 60;
    int remainingSeconds = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void onInit() {
    super.onInit();
    _initAudioRecorder();
  }

  Future<void> _initAudioRecorder() async {
    await audioService.initRecorder();
  }

  Future<void> startRecording() async {
    if (!_isRecording) {
      _isRecording = true;
      _resetTimer();
      _startTimer();
      await audioService.startRecording();
      update();
    }
  }

  Future<void> stopRecording() async {
    if (_isRecording) {
      _isRecording = false;
      _stopTimer();
      recordFilePath = await audioService.stopRecording();
      update();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds++;
      update();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    _seconds = 0;
  }

  Future<void> saveRecording() async {
    if (recordFilePath != null) {
      await globalService.refreshUserData(tokenEntity.accessToken.toString());
      UserDataEntity updatedUserData = globalService.userDataEntity.value!;

      Get.delete<UploadVoiceController>();
      Get.toNamed(AppRoutes.meMyProfileUploadVoice, arguments: {
        'tokenEntity': tokenEntity,
        'userDataEntity': updatedUserData,
        'recordFilePath': recordFilePath,
      });
    }
  }


  void navigateToUploadVoicePage() {
    Get.to(() => UploadVoicePage(), arguments: {
      'tokenEntity': tokenEntity,
      'userDataEntity': userData,
    });
  }


  @override
  void onClose() {
    _timer?.cancel();
    audioService.dispose();
    super.onClose();
  }
}