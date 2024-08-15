import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import '../../../components/photo_dialog.dart';
import 'components/chat/bar/bar.dart';
import 'components/chat/bar/bar_scale_pulse_out_loading.dart';
import 'components/chat_input_bar.dart';
import 'private_chat_controller.dart';
import 'package:first_app/components/background.dart';

class PrivateChatPage extends StatefulWidget {
  const PrivateChatPage({Key? key}) : super(key: key);

  @override
  _PrivateChatPageState createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final PrivateChatController controller = Get.put(PrivateChatController());
  late AnimationController _animationController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentlyPlayingUrl;
  int? _currentlyPlayingIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.scrollController.hasClients) {
        controller.scrollController.animateTo(
          controller.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: true,
            showMiddleText: true,
            showBackgroundImage: false,
            middleText: controller.chattedUser.username.toString(),
            child: const SizedBox.shrink(),
          ),
          Column(
            children: [
              SizedBox(height: 100.h),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(() => ListView.builder(
                    controller: controller.scrollController,
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      final isSentByUser =
                          message.profId == controller.chattedUser.userId;
                      final formattedTime =
                      controller.formatTimestamp(message.created);
                      final avatarUrl =
                          message.sender?.profile?.avatarUrl ?? '';
                      final bool showTimeDivider = index == 0 ||
                          controller.shouldShowTimeDivider(
                            message.created,
                            controller.messages[index - 1].created,
                          );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showTimeDivider)
                            Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: 10.h),
                              child: Center(
                                child: Text(
                                  formattedTime,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.sp),
                                ),
                              ),
                            ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: isSentByUser
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                            children: [
                              if (isSentByUser)
                                CircleAvatar(
                                  radius: 20.w,
                                  backgroundImage: NetworkImage(avatarUrl),
                                ),
                              if (isSentByUser) SizedBox(width: 10.w),
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.h),
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: isSentByUser
                                        ? Colors.blue
                                        : Colors.green,
                                    borderRadius:
                                    BorderRadius.circular(10.w),
                                  ),
                                  child: _buildMessageContent(
                                      message, index),
                                ),
                              ),
                              if (!isSentByUser) SizedBox(width: 10.w),
                              if (!isSentByUser)
                                CircleAvatar(
                                  radius: 20.w,
                                  backgroundImage: NetworkImage(avatarUrl),
                                ),
                            ],
                          ),
                        ],
                      );
                    },
                  )),
                ),
              ),
              ChatInputBar(
                textController: controller.textController,
                onSend: controller.sendTextMessage,
                tokenEntity: controller.tokenEntity,
                chattedUserEntity: controller.chattedUser,
              ),
            ],
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _buildMessageContent(message, int index) {
    switch (message.messageType) {
      case 2: // Image message
        return GestureDetector(
          onTap: () {
            controller.showPhotoDialog(
              context,
              message.url.toString(),
            );
          },
          child: Image.network(
            message.url.toString(),
            width: message.width! / 4.w,
            height: message.height! / 4.h,
            fit: BoxFit.cover,
          ),
        );
      case 3: // Audio message
        return _buildAudioMessage(message, index);
      default: // Text message
        return Text(
          message.message.toString(),
          style: const TextStyle(color: Colors.white),
        );
    }
  }

  Widget _buildAudioMessage(message, int index) {
    double durationSeconds = _getDurationSeconds(message.duration);
    bool isCurrentlyPlaying = _isPlaying && _currentlyPlayingIndex == index;

    return GestureDetector(
      onTap: () => _handleAudioTap(message, index),
      child: Container(
        width: 100.w,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _currentlyPlayingIndex == index
                  ? _animationController
                  : AlwaysStoppedAnimation(0),
              color: Colors.white,
              size: 24.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: SizedBox(
                height: 30.h,
                child: isCurrentlyPlaying
                    ? BarScalePulseOutLoading(
                  width: 2.w,
                  height: 15.h,
                  color: Colors.white,
                  duration: const Duration(milliseconds: 800),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    7,
                        (index) => Bar(
                      color: Colors.white,
                      width: 2.w,
                      height: 15.h,
                      borderRadius: BorderRadius.circular(1.w),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '${durationSeconds.toInt()}"',
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }

  double _getDurationSeconds(dynamic duration) {
    try {
      return double.parse(duration.toString());
    } catch (e) {
      print("Error parsing duration: $e");
      return 0.5;
    }
  }

  void _handleAudioTap(message, int index) async {
    final url = message.url.toString();
    final isSameUrlPlaying =
        _audioPlayer.playing && _currentlyPlayingUrl == url;

    if (isSameUrlPlaying && _currentlyPlayingIndex == index) {
      await _stopAudio();
    } else {
      await _playAudio(url, index);
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    _animationController.reverse();
    setState(() {
      _isPlaying = false;
      _currentlyPlayingUrl = null;
      _currentlyPlayingIndex = null;
    });
  }

  Future<void> _playAudio(String url, int index) async {
    try {
      await _audioPlayer.setUrl(url);
      _audioPlayer.play();
      _animationController.forward();
      setState(() {
        _isPlaying = true;
        _currentlyPlayingUrl = url;
        _currentlyPlayingIndex = index;
      });

      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _animationController.reverse();
          setState(() {
            _isPlaying = false;
            _currentlyPlayingUrl = null;
            _currentlyPlayingIndex = null;
          });
        }
      });
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

