import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/Constant_styles.dart';
import '../../../constants/constant_data.dart';
import '../../../image_res/image_res.dart';
import '../profile_detail/profile_detail_controller.dart';
import 'info_row.dart';


class AboutMeSection extends StatelessWidget {
  final ProfileDetailController controller;

  const AboutMeSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ConstantData.aboutMe, style: ConstantStyles.headlineStyle),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          children: [
            InfoRow(
              iconPath: ImageRes.iconHeight,
              text: controller.userEntity.height != null
                  ? '${controller.userEntity.height}cm'
                  : '',
            ),
            Obx(() {
              if (controller.languageLabel.value.isNotEmpty) {
                return InfoRow(
                  iconPath: ImageRes.iconLanguage,
                  text: controller.languageLabel.value,
                );
              } else {
                return SizedBox.shrink();
              }
            }),
          ],
        ),
      ],
    );
  }
}
