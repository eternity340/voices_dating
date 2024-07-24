import 'package:first_app/components/background.dart';
import 'package:first_app/entity/moment_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../entity/comment_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../components/moments_card.dart';

class MomentsDetailPage extends StatelessWidget {
  final moment = Get.arguments['moment'] as MomentEntity;
  final tokenEntity = Get.arguments['token'] as TokenEntity;
  final userData = Get.arguments['userData'] as UserDataEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackgroundImage: true,
            showSettingButton: true,
            showBackButton: true,
            child: Container(),
          ),
          Positioned(
            left: 20.w,
            top: 109.h,
            right: 20.w,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MomentsCard(
                    showButtons: false,
                    moment: moment,
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: 335.w,
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F8F9),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.w, top: 16.h, bottom: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'likes',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 22 / 18,
                                  letterSpacing: -0.01125,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                moment.likers?.length.toString() ?? '0',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 22 / 18,
                                  letterSpacing: -0.01125,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          if (moment.likers != null && moment.likers!.isNotEmpty)
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: _buildLikeAvatars(moment.likers),
                            ),
                          if (moment.likers == null || moment.likers!.isEmpty)
                            Container(
                              height: 30.h, // Adjust this height as needed
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    width: 335.w,
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F8F9),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.w, top: 16.h, bottom: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Comments',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 22 / 18,
                                  letterSpacing: -0.01125,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          Column(
                            children: _buildCommentWidgets(moment.comments),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLikeAvatars(List<UserDataEntity>? likes) {
    List<Widget> avatars = [];

    int totalAvatars = likes?.length ?? 0;
    int maxAvatars = 16;
    double avatarWidth = 26.75.w;
    double avatarHeight = 30.15.h;

    for (int i = 0; i < totalAvatars && i < maxAvatars; i++) {
      avatars.add(
        Container(
          width: avatarWidth,
          height: avatarHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            image: DecorationImage(
              image: NetworkImage(likes![i].avatar.toString()),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
    return avatars;
  }

  List<Widget> _buildCommentWidgets(List<CommentEntity>? comments) {
    List<Widget> commentWidgets = [];
    bool isLiked = false;

    if (comments != null) {
      for (var comment in comments) {
        commentWidgets.add(
          SizedBox(
            height: 105.h, // 每个评论的高度
            child: Stack(
              children: [
                Positioned(
                  left: 0.w,
                  top: 20.h,
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      image: DecorationImage(
                        image: NetworkImage(comment.avatar?.toString() ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 59.w,
                  top: 15.h,
                  child: Text(
                    comment.username?.toString() ?? '',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      height: 24 / 14,
                      letterSpacing: -0.01,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ),
                Positioned(
                  left: 59.w,
                  top: 40.h,
                  child: Text(
                    _formatTimestamp(comment.commentCreated),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                      height: 24 / 14,
                      letterSpacing: -0.01,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ),
                Positioned(
                  left: 0.w,
                  top: 65.h,
                  child: Text(
                    comment.commentContent?.toString() ?? '',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      height: 24 / 14,
                      letterSpacing: -0.01,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
                Positioned(
                  left: 270.w,
                  top: 15.h,
                  child: GestureDetector(
                    onTap: () {

                    },
                    child: Image.asset(
                      isLiked
                          ? 'assets/images/button_like_active.png'
                          : 'assets/images/button_like_inactive.png',
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                ),
                Positioned(
                  left: 0.w,
                  top: 104.h,
                  right: 16.w,
                  child: Divider(
                    height: 1,
                    color: Color(0xFFEBEBEB),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return commentWidgets;
  }

  String _formatTimestamp(int? timestamp) {
    if (timestamp == null) return '';

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

}
