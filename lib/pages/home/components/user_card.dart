import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/constant_styles.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../image_res/image_res.dart';
import '../../../routes/app_routes.dart';

class UserCard extends StatelessWidget {
  final ListUserEntity userEntity;
  final TokenEntity tokenEntity;

  const UserCard({Key? key, required this.userEntity, required this.tokenEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.homeProfileDetail,
        arguments: {'userEntity': userEntity, 'tokenEntity': tokenEntity},
      ),
      child: Container(
        width: 335.w,
        padding: EdgeInsets.all(10.w),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo(),
                  SizedBox(height: 8.h),
                  _buildSmallPhotos(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return ClipRRect(
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
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                userEntity.username ?? '',
                style: ConstantStyles.cardNameTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 5.w),
            if (userEntity.online == "0")
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
        SizedBox(height: 4.h),
        Row(
          children: [
            Text(userEntity.location?.country ?? '', style: ConstantStyles.userCardTextStyle),
            SizedBox(width: 4.w),
            Text('|', style: ConstantStyles.userCardTextStyle),
            SizedBox(width: 4.w),
            Text('${userEntity.age ?? 0}', style: ConstantStyles.userCardTextStyle),
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
    );
  }

  Widget _buildSmallPhotos() {
    if ((userEntity.photos?.length ?? 0) <= 1) {
      return SizedBox(height: 49.h);
    }
    return Row(
      children: [
        for (var i = 1; i < (userEntity.photos?.length ?? 0) && i < 4; i++)
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: userEntity.photos![i].url != null && userEntity.photos![i].url!.isNotEmpty
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
