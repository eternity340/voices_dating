import 'package:first_app/components/verified_tag.dart';
import 'package:first_app/constants/Constant_styles.dart';
import 'package:first_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/constant_data.dart';
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
        Get.toNamed(AppRoutes.homeProfileDetail,
            arguments: {
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  if (userEntity.member == "1")
                    VerifiedTag(text: ConstantData.superiorText,
                        backgroundColor: Colors.black,
                        textColor: Colors.white
                    ),
                  SizedBox(width: 8.w),
                  if (userEntity.verified == "1")
                    VerifiedTag(
                      text: ConstantData.photosVerified,
                      backgroundColor: Color(0xFFABFFCF),
                      textColor: Colors.black,
                    ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    userEntity.username ?? '',
                                    style: ConstantStyles.cardNameTextStyle,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Text(
                                    userEntity.location?.country ?? '',
                                    style: ConstantStyles.userCardTextStyle
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                    '|',
                                    style: ConstantStyles.userCardTextStyle
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                    '${userEntity.age ?? 0}',
                                    style: ConstantStyles.userCardTextStyle
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
                          ],
                        ),
                        SizedBox(height: 8.h),
                        _buildSmallPhotos(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallPhotos() {
    if ((userEntity.photos?.length ?? 0) <= 1) {
      return SizedBox(height: 49.h);
    }
    return Row(
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
    );
  }
}

