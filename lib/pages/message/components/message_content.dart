import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:voices_dating/net/api_constants.dart';
import '../../../constants/constant_styles.dart';
import '../../../entity/chatted_user_entity.dart';
import '../../../net/dio.client.dart';
import '../message_controller.dart';

class MessageContent extends StatelessWidget {
  final List<ChattedUserEntity> chattedUsers;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoad;
  final MessageController controller;
  final DioClient dioClient = DioClient.instance;

  MessageContent({
    Key? key,
    required this.chattedUsers,
    required this.onRefresh,
    required this.onLoad,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Padding(padding: EdgeInsets.only(bottom: 72.h),
    child: SlidableAutoCloseBehavior(
      child: EasyRefresh(
      onRefresh: onRefresh,
      onLoad: onLoad,
      child: ListView.builder(
        itemCount: chattedUsers.length,
        itemBuilder: (context, index) {
          final user = chattedUsers[index];
          return Slidable(
            key: Key(user.userId.toString()),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.5,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    controller.deleteChat(user);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                controller.navigateToPrivateChat(user);
                controller.sendReadMessageRequest(user);
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
                          child: Row(
                            children: [
                              Text(
                                user.username.toString(),
                                style: ConstantStyles.usernameMessageStyle,
                              ),
                              SizedBox(width: 5.w),
                              if (user.online == "0")
                                Container(
                                  width: 8.w,
                                  height: 8.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFABFFCF),
                                  ),
                                ),
                            ],
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
                        if (user.created != null)
                          Positioned(
                            right: 16.w,
                            top: 24.h,
                            child: Text(
                              controller.formatTime(user.created!),
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
            ),
          );
        },
      ),
    ),
    ),);
  }
}
