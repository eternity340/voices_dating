import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/log_util.dart';
import 'dart:io';
import 'dart:async';

class AudioService {
  static final AudioService instance = AudioService._internal();

  factory AudioService() {
    return instance;
  }

  AudioService._internal();

  audioplayers.AudioPlayer? _audioPlayer;
  FlutterSoundRecorder? _audioRecorder;
  String? _recordingPath;
  bool _isInitialized = false;
  StreamController<void>? _onPlayerCompletionController;

  Future<void> initialize() async {
    if (!_isInitialized) {
      _audioPlayer = audioplayers.AudioPlayer();
      _onPlayerCompletionController = StreamController<void>.broadcast();

      _audioPlayer!.onPlayerStateChanged.listen((audioplayers.PlayerState state) {
        if (state == audioplayers.PlayerState.completed) {
          _onPlayerCompletionController?.add(null);
        }
      });

      _isInitialized = true;
      LogUtil.d(message: 'AudioService initialized');
    }
  }


  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> initRecorder() async {
    bool hasPermission = await requestMicrophonePermission();
    if (!hasPermission) {
      LogUtil.e(message: 'Microphone permission not granted');
      throw Exception('Microphone permission is required');
    }

    _audioRecorder = FlutterSoundRecorder();
    await _audioRecorder!.openRecorder();
  }

  Future<void> startRecording() async {
    if (_audioRecorder != null) {
      try {
        if (!await requestMicrophonePermission()) {
          throw Exception('Microphone permission is required');
        }
        final directory = await getTemporaryDirectory();
        _recordingPath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
        await _audioRecorder!.startRecorder(toFile: _recordingPath);
      } catch (e) {
        LogUtil.e(message: 'Error starting recording: ${e.toString()}');
        _recordingPath = null;
        rethrow;
      }
    }
  }

  Future<String?> stopRecording() async {
    if (_audioRecorder != null) {
      try {
        await _audioRecorder!.stopRecorder();
        return _recordingPath;
      } catch (e) {
        LogUtil.e(message: 'Error stopping recording: ${e.toString()}');
        rethrow;
      }
    }
    return null;
  }

  Future<int> getAudioDuration(String path) async {
    final player = audioplayers.AudioPlayer();
    try {
      await player.setSource(audioplayers.DeviceFileSource(path));
      final duration = await player.getDuration();
      return duration?.inSeconds ?? 0;
    } catch (e) {
      LogUtil.e(message: e.toString());
      return 0;
    } finally {
      await player.dispose();
    }
  }

  Future<void> play(String audioPath) async {
    try {
      await initialize();
      if (_audioPlayer == null) {
        throw Exception('AudioPlayer is not initialized');
      }

      // 检查是否为网络音频 URL
      if (audioPath.startsWith('http://') || audioPath.startsWith('https://')) {
        LogUtil.d(message: 'Attempting to play audio from URL: $audioPath');
        await _audioPlayer!.play(audioplayers.UrlSource(audioPath));
      } else {
        File file = File(audioPath);
        if (!await file.exists()) {
          LogUtil.e(message: 'Audio file does not exist: $audioPath');
          throw FileSystemException('Audio file not found', audioPath);
        }
        LogUtil.d(message: 'Attempting to play audio file: $audioPath');
        await _audioPlayer!.play(audioplayers.DeviceFileSource(audioPath));
      }
      LogUtil.d(message: 'Audio playback started successfully');
    } catch (e) {
      LogUtil.e(message: 'Error playing audio: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer?.pause();
    } catch (e) {
      LogUtil.e(message: 'Error pausing audio: ${e.toString()}');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer?.stop();
    } catch (e) {
      LogUtil.e(message: 'Error stopping audio: ${e.toString()}');
    }
  }

  Future<Duration?> getDuration() async {
    try {
      return await _audioPlayer?.getDuration();
    } catch (e) {
      LogUtil.e(message: 'Error getting duration: ${e.toString()}');
      return null;
    }
  }

  Stream<Duration>? get onPositionChanged => _audioPlayer?.onPositionChanged;
  Stream<Duration>? get onDurationChanged => _audioPlayer?.onDurationChanged;
  Stream<void> get onPlayerCompletion =>
      _onPlayerCompletionController?.stream ?? Stream<void>.empty();


  void dispose() {
    _audioPlayer?.dispose();
    _audioRecorder?.closeRecorder();
    _onPlayerCompletionController?.close();
    _audioPlayer = null;
    _audioRecorder = null;
    _onPlayerCompletionController = null;
    _isInitialized = false;
    LogUtil.d(message: 'AudioService disposed');
  }
}
