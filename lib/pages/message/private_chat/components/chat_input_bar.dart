import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:first_app/constants/Constant_styles.dart';
import 'package:flutter/gestures.dart';
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
import '../../../../image_res/image_res.dart';
import '../../../../service/audio_service.dart';
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
  bool isVoiceMode = false;
  FlutterSoundRecorder? recorder = FlutterSoundRecorder();
  bool isRecording = false;
  final GlobalKey recordButtonKey = GlobalKey();
  final GlobalKey cancelAreaKey = GlobalKey();
  final Uuid uuid = const Uuid();
  OverlayEntry? overlayEntry;
  bool isCancelling = false;
  final double cancelAreaRatio = 0.3;
  final AudioService audioService = AudioService.instance;

  @override
  void initState() {
    super.initState();
    recorder = FlutterSoundRecorder();
    initRecorder();
    initAudioService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
  }

  Future<void> initAudioService() async {
    try {
      await audioService.initRecorder();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize audio: $e')),
      );
    }
  }


  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      await recorder!.openRecorder();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required')),
      );
    }
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
                isVoiceMode
                    ? ImageRes.iconChatMessagePath
                    : ImageRes.iconChatVoiceImagePath,
                width: 18.w,
                height: 18.h,
              ),
              onPressed: _toggleInputMode,
            ),
          ),
          if (isVoiceMode)
            Positioned(
              left: 70.w,
              top: 12.h,
              child: GestureDetector(
                key: recordButtonKey,
                onLongPressDown: onLongPressDown,
                onLongPressUp: onLongPressUp,
                onLongPressStart: onLongPressStart,
                onLongPressEnd: onLongPressEnd,
                onLongPressMoveUpdate: onLongPressMoveUpdate,
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
                      ConstantData.holdToTalkText,
                      style: ConstantStyles.optionSelectedTextStyle,
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
                    hintText: ConstantData.sendMessageText,
                    filled: true,
                    fillColor: Colors.transparent,
                    hintStyle: ConstantStyles.sectionTitle,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          Positioned(
            left: 260.w,
            top: 15.h,
            child: IconButton(
              icon: Image.asset(
                ImageRes.iconChatPhotoImagePath,
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
                      await pickAndUploadPhoto(context, ImageSource.camera);
                      Navigator.pop(context);
                    },
                    onSecondPressed: () async {
                      await pickAndUploadPhoto(context, ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    onCancelPressed: () {
                      Navigator.pop(context);
                    },
                    firstText: ConstantData.takePhotoText,
                    secondText: ConstantData.fromAlbumText,
                  ),
                );
              },
            ),
          ),
          Positioned(
            right: 10.w,
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
              key: cancelAreaKey,
              width: 76.w,
              height: 76.h,
              decoration: BoxDecoration(
                color: const Color(0xFF222120),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  ConstantData.cancelText,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void createOverlay() {
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Material(
              color: Colors.black.withOpacity(0.7),
              child: Stack(
                children: [

                  Center(
                    child: Container(
                      width: 150.w,
                      height: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isCancelling ? Icons.close : Icons.mic,
                            color: Colors.white,
                            size: 50.sp,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            isCancelling
                                ? ConstantData.releaseCancelText
                                : ConstantData.slideUpText,
                            style: TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  void removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }


  void onLongPressDown(LongPressDownDetails details) {
    setState(() {
      isCancelling = false;
    });
  }

  void onLongPressUp() {
    removeOverlay();
  }

  void onLongPressStart(LongPressStartDetails details) async {
    setState(() {
      isRecording = true;
    });
    createOverlay();
    try {
      await audioService.startRecording();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void onLongPressEnd(LongPressEndDetails details) async {
    removeOverlay();
    if (isRecording) {
      try {
        final path = await audioService.stopRecording();
        if (!isCancelling) {
          if (path != null && path.isNotEmpty) {
            final voiceFile = XFile(path);
            LogUtil.d(path);
            await uploadVoice(voiceFile);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Recording failed, path is empty')),
            );
          }
        } else {
          LogUtil.e('Recording cancelled');
        }
      } catch (e) {
        debugPrint('Failed to stop recording: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to stop recording: $e')),
        );
      }
    }

    setState(() {
      isRecording = false;
      isCancelling = false;
    });
  }

  void onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    final offsetY = details.localOffsetFromOrigin.dy;

    bool newIsCancelling = offsetY < -screenHeight * cancelAreaRatio;
    if (newIsCancelling != isCancelling) {
      setState(() {
        isCancelling = newIsCancelling;
      });
      overlayEntry?.markNeedsBuild();
    }
  }


  Future<void> pickAndUploadPhoto(BuildContext context, ImageSource source) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Permission permission = source == ImageSource.camera ? Permission.camera : Permission.photos;

    if (await permission.request().isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        var localId = uuid.v4().toString();
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
        var localId = uuid.v4().toString();
        return await IMService().sendVoice(
          attachId: attachId,
          voiceUrl: voiceUrl,
          receiverId: receiverId.toString(),
          localId: localId,
          duration: duration,
        );
      }
      return false;
    } catch (e) {
      debugPrint('Upload failed: $e');
      return false;
    }
  }

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
      isVoiceMode = !isVoiceMode;
    });
  }

  @override
  void dispose() {
    removeOverlay();
    recorder!.closeRecorder();
    recorder = null;
    super.dispose();
  }
}