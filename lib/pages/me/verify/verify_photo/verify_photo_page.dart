import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../components/background.dart';
import '../../../../components/gradient_btn.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import '../../../../image_res/image_res.dart';
import '../../../../routes/app_routes.dart';
import 'verify_photo_controller.dart';

class VerifyPhotoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VerifyPhotoController controller = Get.put(VerifyPhotoController(
      tokenEntity: Get.arguments['tokenEntity'],
      userData: Get.arguments['userDataEntity'],
    ));

    // 每次构建时检查验证状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.checkVerificationStatus();
    });

    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackgroundImage: false,
            showMiddleText: true,
            showBackButton: true,
            middleText: ConstantData.verifyPhotoText,
            child: Container(),
          ),
          Positioned(
            top: 95.h,
            left: (ScreenUtil().screenWidth - 335.w) / 2,
            child: GestureDetector(
              onTap: controller.pickImage,
              child: Obx(() => Container(
                width: 335.w,
                height: 351.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F9),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: controller.image.value == null
                    ? Center(
                  child: Image.asset(
                    ImageRes.imagePathIconPicture,
                    width: 48.w,
                    height: 48.h,
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.file(
                    controller.image.value!,
                    fit: BoxFit.cover,
                  ),
                ),
              )),
            ),
          ),
          Positioned(
            top: 462.h,
            left: 16.w,
            right: 16.w,
            child: Text(
              ConstantData.verifyContentText,
              textAlign: TextAlign.center,
              style: ConstantStyles.verifyPhotoTextStyle,
            ),
          ),
          Positioned(
            top: 572.h,
            left: 0,
            right: 0,
            child: Center(
              child: GradientButton(
                text: ConstantData.uploadText,
                onPressed: controller.uploadImage,
                height: 49.h,
                width: 248.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

