import 'package:first_app/components/background.dart';
import 'package:first_app/entity/moment_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../components/comments_widget.dart';
import '../components/moments_card.dart';
class MomentsDetailPage extends StatefulWidget {
  @override
  _MomentsDetailPageState createState() => _MomentsDetailPageState();
}

class _MomentsDetailPageState extends State<MomentsDetailPage> {
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
                          CommentWidget(moment: moment, tokenEntity: tokenEntity), // 使用 CommentWidget
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

  List<Widget> _buildLikeAvatars(List<UserDataEntity>? likers) {
    if (likers == null) return [];

    List<Widget> likeAvatars = [];
    for (var liker in likers) {
      likeAvatars.add(
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            image: DecorationImage(
              image: NetworkImage(liker.avatar?.toString() ?? ''),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
    return likeAvatars;
  }
}
