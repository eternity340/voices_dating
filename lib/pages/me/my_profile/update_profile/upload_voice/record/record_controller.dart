import 'dart:async';
import 'package:get/get.dart';
import '../../../../../../entity/token_entity.dart';
import '../../../../../../entity/user_data_entity.dart';
import '../../../../../../service/audio_service.dart';
import '../upload_voice_controller.dart';


class RecordController extends GetxController {
  final TokenEntity tokenEntity;
  final UserDataEntity userData;
  final AudioService audioService = AudioService();

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
      Get.delete<UploadVoiceController>();
      Get.toNamed('/me/my_profile/upload_voice', arguments: {
        'token': tokenEntity,
        'userData': userData,
        'recordFilePath': recordFilePath,
      });
    }
  }


  @override
  void onClose() {
    _timer?.cancel();
    audioService.dispose();
    super.onClose();
  }
}