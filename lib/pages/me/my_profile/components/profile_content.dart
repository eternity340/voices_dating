import 'package:voices_dating/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../../../../image_res/image_res.dart';

class ProfileContent extends StatelessWidget {
  final TokenEntity tokenEntity;
  final UserDataEntity userData;

  ProfileContent({required this.tokenEntity, required this.userData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(
              context,
              title: ConstantData.usernameTitle,
              value: userData.username,
              onTap: () {
                Get.toNamed(AppRoutes.meMyProfileChangeUsername,
                    arguments: {'tokenEntity': tokenEntity, 'userDataEntity': userData});
              },
            ),
            _buildInfoSection(
              context,
              title: ConstantData.ageTitle,
              value: userData.age.toString(),
              onTap: () {
                Get.toNamed(AppRoutes.meMyProfileChangeAge,
                    arguments: {'tokenEntity': tokenEntity, 'userDataEntity': userData});
              },
            ),
            _buildInfoSection(
              context,
              title: ConstantData.heightTitle,
              value: userData.height != null ? '${userData.height} cm' : '',
              onTap: () {
                Get.toNamed(AppRoutes.meMyProfileChangeHeight,
                    arguments: {'tokenEntity': tokenEntity, 'userDataEntity': userData});
              },
            ),
            _buildInfoSection(
              context,
              title: ConstantData.headlineTitle,
              value: userData.headline.toString(),
              onTap: () {
                Get.toNamed(AppRoutes.meMyProfileChangeHeadline,
                    arguments: {'tokenEntity': tokenEntity, 'userDataEntity': userData});
              },
            ),
            _buildInfoSection(
              context,
              title: ConstantData.locationTitle,
              value: getFormattedLocation(),
              onTap: () {
                Get.toNamed(AppRoutes.meMyProfileChangeLocation,
                    arguments: {'tokenEntity': tokenEntity, 'userDataEntity': userData});
              },
            ),
            _buildInfoSection(
                context,
                title: ConstantData.voiceIntroduction,
                value: userData.voice?.description ?? ConstantData.noVoiceText,
                onTap: () {
                  Get.toNamed(AppRoutes.meMyProfileUploadVoice,
                      arguments: {'tokenEntity': tokenEntity, 'userDataEntity': userData});
                }
            ),
         /*   _buildInfoSection(
              context,
              title: ConstantData.languageTitle,
              value: userData.language.toString(),
              onTap: () {
                Get.toNamed(AppRoutes.meMyProfileChangeLanguage,
                    arguments: {'tokenEntity': tokenEntity, 'userDataEntity': userData}
                );
              },
            ),*/
            _buildInfoSection(
              context,
              title: ConstantData.tagsTitle,
              value: '',
              onTap: () {
                Get.toNamed(AppRoutes.meMyProfileAddTags,
                    arguments: {'tokenEntity': tokenEntity, 'userDataEntity': userData}
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, {
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: ConstantStyles.sectionTitle,
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: 270.w),
            child: Image.asset(
              ImageRes.pathIcon,
              width: 18.w,
              height: 18.h,
            ),
          ),
        ),
        Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250.w),
              child: Text(
                value,
                style: ConstantStyles.sectionValue,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Container(
          width: 330.w,
          height: 1.h,
          color: Color(0xFFEBEBEB),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  String getFormattedLocation() {
    List<String> locationParts = [];
    if (userData.location?.city?.isNotEmpty == true) {
      locationParts.add(userData.location!.city!);
    }
    if (userData.location?.state?.isNotEmpty == true) {
      locationParts.add(userData.location!.state!);
    }
    if (userData.location?.country?.isNotEmpty == true) {
      locationParts.add(userData.location!.country!);
    }
    return locationParts.join(', ');
  }

}
