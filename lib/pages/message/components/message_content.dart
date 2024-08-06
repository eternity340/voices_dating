import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../constants/Constant_styles.dart';
import '../../../entity/chatted_user_entity.dart';

class MessageContent extends StatelessWidget {
  final List<ChattedUserEntity> chattedUsers;
  final Future<void> Function() onRefresh;

  const MessageContent({
    Key? key,
    required this.chattedUsers,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: chattedUsers.length,
        itemBuilder: (context, index) {
          final user = chattedUsers[index];
          return Column(
            children: [
              Container(
                height: 100.h, // 确保每个项有固定高度
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
                        left: 65.w, // 修改位置，以确保在头像的右下角
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
                          _formatTime(user.lastactivetime!),
                          style: ConstantStyles.lastActiveTimeStyle
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10.h), // 添加15.5px的空白区域
              Divider(
                thickness: 1,
                color: Color(0xFFEBEBEB),
                indent: 16.w,
                endIndent: 16.w,
                height: 1,
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final formatter = DateFormat('hh:mm a');
    return formatter.format(date);
  }
}
