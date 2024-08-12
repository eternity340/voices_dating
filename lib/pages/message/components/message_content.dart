import 'package:dio/dio.dart';
import 'package:first_app/entity/user_data_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../constants/constant_styles.dart';
import '../../../entity/chatted_user_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../net/dio.client.dart';
import '../message_controller.dart';

class MessageContent extends StatelessWidget {
  final List<ChattedUserEntity> chattedUsers;
  final Future<void> Function() onRefresh;
  final TokenEntity tokenEntity;
  final MessageController controller;

  const MessageContent({
    super.key,
    required this.chattedUsers,
    required this.onRefresh,
    required this.tokenEntity,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: chattedUsers.length,
        itemBuilder: (context, index) {
          final user = chattedUsers[index];
          return GestureDetector(
            onTap: () {
              _navigateToPrivateChat(user);
              _sendReadMessageRequest(user);
            },
            child: Column(
              children: [
                Container(
                  height: 100.h,
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 19.w,
                        top: 16.h,
                        child: CircleAvatar(
                          radius: 31.w,
                          backgroundImage: NetworkImage(user.avatar.toString()),
                        ),
                      ),
                      if (user.newNumber != null && user.newNumber != '0')
                        Positioned(
                          left: 65.w,
                          bottom: 8.h,
                          child: Container(
                            width: 15.w,
                            height: 15.h,
                            decoration: BoxDecoration(
                              color: Color(0xFFFF3737),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                user.newNumber.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        left: 90.w,
                        top: 20.h,
                        child: Text(
                          user.username.toString(),
                          style: ConstantStyles.usernameMessageStyle,
                        ),
                      ),
                      Positioned(
                        left: 90.w,
                        top: 51.h,
                        right: 60.w,
                        child: Text(
                          user.lastmessage.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: ConstantStyles.lastMassageStyle,
                        ),
                      ),
                      if (user.lastactivetime != null)
                        Positioned(
                          right: 16.w,
                          top: 24.h,
                          child: Text(
                            _formatTime(user.created!),
                            style: ConstantStyles.lastActiveTimeStyle,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Divider(
                  thickness: 1,
                  color: Color(0xFFEBEBEB),
                  indent: 16.w,
                  endIndent: 16.w,
                  height: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToPrivateChat(ChattedUserEntity user) {
    Get.toNamed('/message/private_chat', arguments: {
      'token': tokenEntity,
      'chattedUser': user,
    })?.then((_) {
      controller.clearNewNumber(user.userId.toString());
    });
  }

  void _sendReadMessageRequest(ChattedUserEntity user) {
    DioClient.instance.requestNetwork(
      url: 'https://api.masonvips.com/v1/read/message',
      queryParameters: {
        'profId': user.userId,
      },
      options: Options(
        headers: {
          'token': tokenEntity.accessToken,
        },
      ),
      onSuccess: (data) {
        print('Request successful');
      },
      onError: (code, msg, data) {
        print('Request failed: $msg');
      },
    );
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final formatter = DateFormat('hh:mm a');
    return formatter.format(date);
  }
}
