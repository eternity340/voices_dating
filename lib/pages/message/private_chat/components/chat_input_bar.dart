
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../../../../components/bottom_options.dart';
import '../../../../constants/constant_data.dart';
import '../../../../entity/chatted_user_entity.dart';
import '../../../../entity/token_entity.dart';
import '../../../../service/im_service.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController textController;
  final VoidCallback onSend;
  final TokenEntity tokenEntity;
  final ChattedUserEntity chattedUserEntity;

  const ChatInputBar({
    super.key,
    required this.textController,
    required this.onSend,
    required this.tokenEntity,
    required this.chattedUserEntity,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool _isVoiceMode = false;
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  Offset _startPosition = Offset.zero;
  final GlobalKey _recordButtonKey = GlobalKey();
  final GlobalKey _cancelAreaKey = GlobalKey();
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      await _recorder!.openRecorder();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required')),
      );
    }
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _recorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x5CD4D7E0),
            blurRadius: 89.76.sp,
            offset: Offset(0, -20.h),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10.w,
            top: 15.5.h,
            child: IconButton(
              icon: Image.asset(
                _isVoiceMode ? 'assets/images/icon_chat_message.png' : 'assets/images/icon_chat_voice.png',
                width: 18.w,
                height: 18.h,
              ),
              onPressed: _toggleInputMode,
            ),
          ),
          if (_isVoiceMode)
            Positioned(
              left: 70.w,
              top: 12.h,
              child: GestureDetector(
                key: _recordButtonKey,
                onLongPressStart: _onLongPressStart,
                onLongPressMoveUpdate: _onLongPressMoveUpdate,
                onLongPressEnd: _onLongPressEnd,
                child: Container(
                  width: 185.w,
                  height: 49.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF20E2D7), Color(0xFFD8FAAD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: Text(
                      _isRecording ? "Release to Send" : "Hold to Talk",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: ConstantData.fontPoppins,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            Positioned(
              left: 70.w,
              top: 12.h,
              child: Container(
                width: 185.w,
                height: 49.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F9),
                  borderRadius: BorderRadius.circular(24.5.w),
                ),
                child: TextField(
                  controller: widget.textController,
                  decoration: InputDecoration(
                    hintText: "Send a message…",
                    filled: true,
                    fillColor: Colors.transparent,
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: const Color(0xFF8E8E93),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                  ),
                ),
              ),
            ),
          Positioned(
            left: 270.w,
            top: 15.h,
            child: IconButton(
              icon: Image.asset(
                'assets/images/icon_chat_photo.png',
                width: 24.w,
                height: 24.h,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => BottomOptions(
                    onFirstPressed: () async {
                      await _pickAndUploadPhoto(context, ImageSource.camera);
                      Navigator.pop(context);
                    },
                    onSecondPressed: () async {
                      await _pickAndUploadPhoto(context, ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    onCancelPressed: () {
                      Navigator.pop(context);
                    },
                    firstText: 'Take Photo',
                    secondText: 'From Album',
                  ),
                );
              },
            ),
          ),
          Positioned(
            right: 20.w,
            top: 15.h,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.black),
              onPressed: widget.onSend,
            ),
          ),
          Positioned(
            left: 20.w,
            top: 564.h,
            child: Container(
              key: _cancelAreaKey,
              width: 76.w,
              height: 76.h,
              decoration: BoxDecoration(
                color: const Color(0xFF222120),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Gesture Handlers
  void _onLongPressStart(LongPressStartDetails details) async {
    setState(() {
      _isRecording = true;
      _startPosition = details.localPosition;
    });
    try {
      if (_recorder!.isStopped) {
        await _recorder!.startRecorder(
            toFile: 'audio_${_uuid.v4()}.aac'
        );
      }
    } catch (e) {
      debugPrint('Error starting recorder: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to start recording')),
      );
    }
  }



  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    RenderBox? box = _cancelAreaKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      Offset cancelAreaPosition = box.localToGlobal(Offset.zero);
      Size cancelAreaSize = box.size;

      // Check if finger is within the cancel area
      if (details.globalPosition.dx >= cancelAreaPosition.dx &&
          details.globalPosition.dx <= cancelAreaPosition.dx + cancelAreaSize.width &&
          details.globalPosition.dy >= cancelAreaPosition.dy &&
          details.globalPosition.dy <= cancelAreaPosition.dy + cancelAreaSize.height) {
        setState(() {
          _isRecording = false;
        });
        _recorder!.stopRecorder();
      }
    }
  }

  void _onLongPressEnd(LongPressEndDetails details) async {
    if (_isRecording) {
      try {
        final path = await _recorder!.stopRecorder();
        if (path != null && path.isNotEmpty) {
          final voiceFile = XFile(path);
          debugPrint('Recording stopped: $path');
          await uploadVoice(voiceFile);
        } else {
          debugPrint('Recording path is null or empty');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recording failed, path is empty')),
          );
        }
      } catch (e) {
        debugPrint('Failed to stop recording: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to stop recording')),
        );
      }
    }
    setState(() {
      _isRecording = false;
    });
  }


  Future<void> _pickAndUploadPhoto(BuildContext context, ImageSource source) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Permission permission = source == ImageSource.camera ? Permission.camera : Permission.photos;

    if (await permission.request().isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        var localId = _uuid.v4().toString();
        var success = await uploadImage(image, localId);
        if (success) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Image sent successfully')),
          );
        } else {
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Failed to send image')),
          );
        }
      }
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Permission denied')),
      );
    }
  }

  Future<bool> uploadImage(XFile image, String localId) async {
    try {
      var dio = Dio();
      var response = await dio.post(
        'https://api.masonvips.com/v1/upload_file',
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(image.path),
        }),
        options: Options(
          headers: {
            'token': widget.tokenEntity.accessToken,
          },
        ),
      );

      if (response.data['code'] == 200) {
        var attachId = response.data['data'][0]['attachId'].toString();
        var imageUrl = response.data['data'][0]['url'].toString();
        var receiverId = widget.chattedUserEntity.userId;

        // Send image
        return await IMService().sendImage(
          attachId: attachId,
          imageUrl: imageUrl,
          receiverId: receiverId.toString(),
          localId: localId,
        );
      }
      return false;
    } catch (e) {
      debugPrint('Upload failed: $e');
      return false;
    }
  }

  Future<bool> uploadVoice(XFile voice) async {
    try {
      // 计算音频持续时间
      final duration = await _getAudioDuration(voice.path);

      var dio = Dio();
      var response = await dio.post(
        'https://api.masonvips.com/v1/upload_file',
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(voice.path),
        }),
        options: Options(
          headers: {
            'token': widget.tokenEntity.accessToken,
          },
        ),
      );

      if (response.data['code'] == 200) {
        var attachId = response.data['data'][0]['attachId'].toString();
        var voiceUrl = response.data['data'][0]['url'].toString();
        var receiverId = widget.chattedUserEntity.userId;
        var localId = _uuid.v4().toString();

        // Send voice
        return await IMService().sendVoice(
          attachId: attachId,
          voiceUrl: voiceUrl,
          receiverId: receiverId.toString(),
          localId: localId,
          duration: duration, // 直接传递整数
        );
      }
      return false;
    } catch (e) {
      debugPrint('Upload failed: $e');
      return false;
    }
  }

// 计算音频持续时间的方法保持不变
  Future<int> _getAudioDuration(String path) async {
    try {
      final audioPlayer = AudioPlayer();
      final duration = await audioPlayer.setFilePath(path);
      await audioPlayer.dispose();
      return duration?.inSeconds ?? 0;
    } catch (e) {
      debugPrint('Error getting audio duration: $e');
      return 0;
    }
  }

  void _toggleInputMode() {
    setState(() {
      _isVoiceMode = !_isVoiceMode;
    });
  }
}