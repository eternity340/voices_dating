import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:first_app/constants/Constant_styles.dart';
import '../../../components/verified_tag.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/chatted_user_entity.dart';
import '../../../routes/app_routes.dart';
import '../message_controller.dart';

class ViewedMeContent extends StatefulWidget {
  final MessageController controller;

  const ViewedMeContent({Key? key, required this.controller}) : super(key: key);

  @override
  _ViewedMeContentState createState() => _ViewedMeContentState();
}

class _ViewedMeContentState extends State<ViewedMeContent> {
  late EasyRefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return EasyRefresh(
        controller: _refreshController,
        onRefresh: () async {
          await widget.controller.getViewedMeUsers();
          _refreshController.finishRefresh();
        },
        child: widget.controller.visitedMeUsers.isEmpty
            ? Center(child: Text('No one has viewed your profile yet.'))
            : ListView.builder(
          itemCount: widget.controller.visitedMeUsers.length,
          itemBuilder: (context, index) {
            final user = widget.controller.visitedMeUsers[index];
            return _buildUserItem(user);
          },
        ),
      );
    });
  }

  Widget _buildUserItem(ListUserEntity user) {
    return GestureDetector(
      onTap: () => _navigateToPrivateChat(user),
      child: Column(
        children: [
          Container(
            height: 100.h,
            padding: EdgeInsets.only(left: 19.w, top: 16.h, right: 19.w),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 31.r,
                    backgroundImage: NetworkImage(user.avatar ?? ''),
                  ),
                ),
                Positioned(
                  left: 70.w,
                  top: 0.h,
                  child: Text(
                    user.username ?? '',
                    style: ConstantStyles.usernameMessageStyle,
                  ),
                ),
                Positioned(
                  left: 70.w,
                  top: 30.h,
                  child: Row(
                    children: [
                      if(user.member == '1')
                        VerifiedTag(
                          text: ConstantData.superiorText,
                          backgroundColor: Color(0xFFFFA6CB),
                          textColor: Colors.black,
                        ),
                      if(user.member == '1')
                      SizedBox(width: 8.w),
                      if(user.verified == '1')
                        VerifiedTag(
                          text: ConstantData.photosVerified,
                          backgroundColor: Color(0xFFD7FAAD),
                          textColor: Colors.black,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 303.w,
            height: 1.h,
            color: Color(0xFFEBEBEB),
          ),
        ],
      ),
    );
  }

  void _navigateToPrivateChat(ListUserEntity user) {
    ChattedUserEntity chattedUser = ChattedUserEntity(
      userId: user.userId,
      username: user.username,
      avatar: user.avatar,
    );

    Get.toNamed(AppRoutes.messagePrivateChat, arguments: {
      'token': widget.controller.tokenEntity,
      'chattedUser': chattedUser,
      'userData':widget.controller.userDataEntity
    });
  }
}