import 'package:first_app/components/verified_tag.dart';
import 'package:first_app/constants/Constant_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../image_res/image_res.dart';

class UserCard extends StatelessWidget {
  final ListUserEntity userEntity;
  final TokenEntity tokenEntity;

  UserCard({super.key, required this.userEntity, required this.tokenEntity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/home/profile_detail', arguments: {
          'userEntity': userEntity,
          'tokenEntity': tokenEntity,
        });
      },
      child: Container(
        width: 335.w,
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
              children: [
                if (userEntity.member == "1")
                   VerifiedTag(text: 'Superior',
                    backgroundColor: Colors.black,
                    textColor: Colors.white
                  ),
                SizedBox(width: 8.w),
                if (userEntity.verified == "1")
                  VerifiedTag(
                    text: 'Photos verified',
                    backgroundColor: Color(0xFFABFFCF),
                    textColor: Colors.black,
                  ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: userEntity.avatar != null && userEntity.avatar!.isNotEmpty
                      ? Image.network(
                    userEntity.avatar!,
                    width: 100.w,
                    height: 129.h,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    ImageRes.placeholderAvatar,
                    width: 100.w,
                    height: 129.h,
                    fit: BoxFit.cover,
                  ),
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
                            Expanded(
                              child: Text(
                                userEntity.username ?? '',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontFamily: 'Open Sans',
                                  height: 22 / 18, // 行高
                                  letterSpacing: -0.01125,
                                  color: Color(0xFF000000),
                                ),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 5.w)
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              userEntity.location?.country ?? '',
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
                              '${userEntity.age ?? 0}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: 'Open Sans',
                                color: Color(0xFF8E8E93),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          userEntity.headline ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ConstantStyles.headlineUserCardStyle,
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            for (var i = 1;
                            i < (userEntity.photos?.length ?? 0) && i < 4;
                            i++)
                              Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: userEntity.photos![i].url != null &&
                                      userEntity.photos![i].url!.isNotEmpty
                                      ? Image.network(
                                    userEntity.photos![i].url!,
                                    width: 37.98.w,
                                    height: 49.h,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.asset(
                                    ImageRes.placeholderAvatar,
                                    width: 37.98.w,
                                    height: 49.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

