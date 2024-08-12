import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../entity/im_new_message_emtity.dart';
import 'components/chat_input_bar.dart';
import 'private_chat_controller.dart';
import 'package:first_app/components/background.dart';

class PrivateChatPage extends StatefulWidget {
  @override
  _PrivateChatPageState createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> with WidgetsBindingObserver {
  final PrivateChatController controller = Get.put(PrivateChatController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.scrollController.hasClients) {
        controller.scrollController.animateTo(
          controller.scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
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
            child: Container(),
          ),
          Positioned.fill(
            child: Column(
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
                        final isSentByUser = message.profId == controller.chattedUser.userId;
                        final formattedTime = controller.formatTimestamp(message.created);
                        final avatarUrl = message.sender?.profile?.avatarUrl ?? '';
                        final bool showTimeDivider = index == 0 || controller.shouldShowTimeDivider(message.created, controller.messages[index - 1].created);

                        return Column(
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
                              mainAxisAlignment: isSentByUser ? MainAxisAlignment.start : MainAxisAlignment.end,
                              children: [
                                if (isSentByUser)
                                  CircleAvatar(
                                    radius: 20.w,
                                    backgroundImage: NetworkImage(avatarUrl),
                                  ),
                                if (isSentByUser)
                                  SizedBox(width: 10.w),
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 10.h),
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: isSentByUser ? Colors.blue : Colors.green,
                                      borderRadius: BorderRadius.circular(10.w),
                                    ),
                                    child: Text(
                                      message.message.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                if (!isSentByUser)
                                  SizedBox(width: 10.w),
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
                  messageController: controller.messageController,
                  onSend: controller.sendTextMessage,
                ),
              ],
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}