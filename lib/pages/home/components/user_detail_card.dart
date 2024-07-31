import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart';
import 'audio_player_widget.dart';

class UserDetailCard extends StatelessWidget {
  final ListUserEntity userEntity;
  final TokenEntity tokenEntity;

  UserDetailCard({required this.userEntity, required this.tokenEntity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/home/profile_detail', arguments: {
          'userEntity': userEntity,
          'tokenEntity':tokenEntity
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        child: Container(
          width: 335.w,
          height: 221.21.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 14.r,
                offset: Offset(0, 7.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(
                          userEntity.avatar ?? 'assets/images/placeholder1.png',
                          width: 100.w,
                          height: 129.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 88.w,
                        height: 19.h,
                        decoration: BoxDecoration(
                          color: Color(0xFFABFFCF),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Center(
                          child: Text(
                            'Photos verified',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontFamily: 'Open Sans',
                              letterSpacing: 0.02,
                              color: Color(0xFF262626),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                userEntity.username ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontFamily: 'Open Sans',
                                  height: 22 / 18,
                                  letterSpacing: -0.01125,
                                  color: Color(0xFF000000),
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 0.h, width: 6.w),
                              Container(
                                width: 9.w,
                                height: 9.h,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFABFFCF),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text(
                                userEntity.location?.state ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'Open Sans',
                                  color: Color(0xFF8E8E93),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '|',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'Open Sans',
                                  color: Color(0xFF8E8E93),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                userEntity.age?.toString() ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'Open Sans',
                                  color: Color(0xFF8E8E93),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40.h),
                          AudioPlayerWidget(audioPath: 'audio/AI_Sunday.mp3'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
