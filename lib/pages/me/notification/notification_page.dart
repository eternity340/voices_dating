import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:first_app/constants/Constant_styles.dart';
import 'package:first_app/constants/constant_data.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../entity/notification_entity.dart';
import '../../../net/dio.client.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final TokenEntity tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
  final UserDataEntity userData = Get.arguments['userDataEntity'] as UserDataEntity;
  List<NotificationEntity> notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  void _fetchNotifications() {
    DioClient.instance.requestNetwork<List<NotificationEntity>>(
      method: Method.get,
      url: ApiConstants.getNotification,
      options: Options(headers: {'token': tokenEntity.accessToken}),
      onSuccess: (data) {
        setState(() {
          notifications = data ?? [];
        });
      },
      onError: (code, msg, data) {
        LogUtil.e(msg);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: true,
            showSettingButton: false,
            showBackgroundImage: false,
            showMiddleText: true,
            middleText: ConstantData.notificationTitle,
            child: Container(),
          ),
          Positioned(
            top: 139.h,
            left: 10.w,
            child: Container(
              width: 335.w,
              height: 680.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F9),
                borderRadius: BorderRadius.circular(24.r),
                backgroundBlendMode: BlendMode.srcOver,
              ),
              child: ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    height: 80.h,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 16.w,
                          top: 10.h,
                          child: CircleAvatar(
                            radius: 30.r,
                            backgroundImage: NetworkImage(notifications[index].avatar ?? ''),
                          ),
                        ),
                        Positioned(
                          left: 86.w,
                          top: 25.h,
                          right: 16.w,
                          child: Text(
                            notifications[index].username ?? '',
                            style: ConstantStyles.usernameMessageStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
