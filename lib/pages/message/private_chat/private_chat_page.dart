import 'dart:async';
import 'package:voices_dating/constants/Constant_styles.dart';
import 'package:voices_dating/service/global_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import '../../../components/bar/bar.dart';
import '../../../components/bar/bar_scale_pulse_out_loading.dart';
import '../../../components/photo_dialog.dart';
import '../../../image_res/image_res.dart';
import 'components/chat_input_bar.dart';
import 'private_chat_controller.dart';
import 'package:voices_dating/components/background.dart';

class PrivateChatPage extends StatefulWidget {
  const PrivateChatPage({Key? key}) : super(key: key);

  @override
  _PrivateChatPageState createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final PrivateChatController controller = Get.put(PrivateChatController());
  final GlobalService globalService = Get.find();
  late EasyRefreshController _easyRefreshController;
  late AnimationController _animationController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentlyPlayingUrl;
  int? _currentlyPlayingIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _easyRefreshController = EasyRefreshController();
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
      body: Background(
        showBackButton: true,
        showMiddleText: true,
        showBackgroundImage: false,
        middleText: controller.chattedUser.username.toString(),
        child: Stack(
        children: [
          Positioned(
            right:10.w,
            top: 0.h,
            child: GestureDetector(
              onTap: () => controller.showOptionsBottomSheet(context),
              child: Image.asset(
                ImageRes.imagePathSettingButton,
                width: 40.w,
                height: 40.h,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 50.h),
              Expanded(
                child: Obx(() => EasyRefresh(
                    controller: _easyRefreshController,
                    header: ClassicalHeader(
                      refreshText: "Pull to load more",
                      refreshReadyText: "Release to load more",
                      refreshingText: "Loading...",
                      refreshedText: "Loaded successfully",
                      bgColor: Colors.transparent,
                      textColor: Colors.grey,
                      infoColor: Colors.grey,
                    ),
                    onRefresh: () async {
                      await controller.loadMoreMessages();
                      _easyRefreshController.finishRefresh();
                    },
                  child: ListView.builder(
                    controller: controller.scrollController,
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      final isSentByChatUser = message.profId == controller.chattedUser.userId;
                      final formattedTime = controller.formatTimestamp(message.created);
                      final avatarUrl = message.sender?.profile?.avatarUrl ?? '';
                      final bool showTimeDivider = index == 0 ||
                          controller.shouldShowTimeDivider(
                            message.created,
                            controller.messages[index - 1].created,
                          );
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (showTimeDivider)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Center(
                                  child: Text(
                                    formattedTime,
                                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                                  ),
                                ),
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: isSentByChatUser
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                if (isSentByChatUser)
                                  GestureDetector(
                                    onTap: () => controller.onAvatarTap(controller.chattedUser.userId ?? ''),
                                    child: CircleAvatar(
                                      radius: 20.w,
                                      backgroundImage: NetworkImage(avatarUrl),
                                    ),
                                  ),
                                if (isSentByChatUser) SizedBox(width: 10.w),
                                Flexible(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 0.73 - 32.w,
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 10.h),
                                      padding: EdgeInsets.all(10.w),
                                      decoration: BoxDecoration(
                                        color: isSentByChatUser
                                            ? Color(0xFFFFAFAB)
                                            : Color(0xFFABFFCF),
                                        borderRadius: BorderRadius.circular(10.w),
                                      ),
                                      child: _buildMessageContent(message, index),
                                    ),
                                  ),
                                ),
                                if (!isSentByChatUser) SizedBox(width: 10.w),
                                if (!isSentByChatUser)
                                  GestureDetector(
                                    onTap: () => controller.onAvatarTap(controller.userDataEntity.userId ?? ''),
                                    child: CircleAvatar(
                                      radius: 20.w,
                                      backgroundImage: NetworkImage(avatarUrl),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )),
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.w), // 添加圆角
            child: Container(
              constraints: BoxConstraints(
                maxWidth: message.width/4.w,
                maxHeight: message.height/4.w,
              ),
              child: Image.network(
                message.url.toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      case 3: // Audio message
        return _buildAudioMessage(message, index);
      default: // Text message
        return Text(
          message.message.toString(),
          style: ConstantStyles.yourIdTextStyle
        );
    }
  }

  Widget _buildAudioMessage(message, int index) {
    double durationSeconds = _getDurationSeconds(message.duration);
    bool isCurrentlyPlaying = _isPlaying && _currentlyPlayingIndex == index;

    return GestureDetector(
      onTap: () => _handleAudioTap(message, index),
      child: Container(
        width: 60.w,
        height: 20.h,
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 20.w,
              child: Center(
                child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: _currentlyPlayingIndex == index
                      ? _animationController
                      : AlwaysStoppedAnimation(0),
                  color: Colors.black,
                  size: 20.sp,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: SizedBox(
                height: 30.h,
                child: isCurrentlyPlaying
                    ? BarScalePulseOutLoading(
                  width: 2.w,
                  height: 15.h,
                  color: Colors.black,
                  duration: const Duration(milliseconds: 800),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    5,
                        (index) => Bar(
                      color: Colors.black,  // Changed to black
                      width: 2.w,
                      height: 15.h,
                      borderRadius: BorderRadius.circular(1.w),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 18.w,
              child: Text(
                '${durationSeconds.toInt()}"',
                style: TextStyle(color: Colors.black, fontSize: 12.sp),
                textAlign: TextAlign.right,
              ),
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
    _easyRefreshController.dispose();
    globalService.setNeedRefresh(true);

    super.dispose();
  }
}

/*Stack(
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
                child: Obx(() => EasyRefresh(
                    controller: _easyRefreshController,
                    header: ClassicalHeader(
                      refreshText: "Pull to load more",
                      refreshReadyText: "Release to load more",
                      refreshingText: "Loading...",
                      refreshedText: "Loaded successfully",
                      bgColor: Colors.transparent,
                      textColor: Colors.grey,
                      infoColor: Colors.grey,
                    ),
                    onRefresh: () async {
                      await controller.loadMoreMessages();
                      _easyRefreshController.finishRefresh();
                    },
                  child: ListView.builder(
                    controller: controller.scrollController,
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      final isSentByChatUser = message.profId == controller.chattedUser.userId;
                      final formattedTime = controller.formatTimestamp(message.created);
                      final avatarUrl = message.sender?.profile?.avatarUrl ?? '';
                      final bool showTimeDivider = index == 0 ||
                          controller.shouldShowTimeDivider(
                            message.created,
                            controller.messages[index - 1].created,
                          );
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (showTimeDivider)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Center(
                                  child: Text(
                                    formattedTime,
                                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                                  ),
                                ),
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: isSentByChatUser
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                if (isSentByChatUser)
                                  GestureDetector(
                                    onTap: () => controller.onAvatarTap(controller.chattedUser.userId ?? ''),
                                    child: CircleAvatar(
                                      radius: 20.w,
                                      backgroundImage: NetworkImage(avatarUrl),
                                    ),
                                  ),
                                if (isSentByChatUser) SizedBox(width: 10.w),
                                Flexible(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 0.73 - 32.w,
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 10.h),
                                      padding: EdgeInsets.all(10.w),
                                      decoration: BoxDecoration(
                                        color: isSentByChatUser
                                            ? Color(0xFFFFAFAB)
                                            : Color(0xFFABFFCF),
                                        borderRadius: BorderRadius.circular(10.w),
                                      ),
                                      child: _buildMessageContent(message, index),
                                    ),
                                  ),
                                ),
                                if (!isSentByChatUser) SizedBox(width: 10.w),
                                if (!isSentByChatUser)
                                  GestureDetector(
                                    onTap: () => controller.onAvatarTap(controller.userDataEntity.userId ?? ''),
                                    child: CircleAvatar(
                                      radius: 20.w,
                                      backgroundImage: NetworkImage(avatarUrl),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )),
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
      )*/