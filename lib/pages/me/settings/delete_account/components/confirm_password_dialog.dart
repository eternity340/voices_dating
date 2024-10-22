import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voices_dating/constants/Constant_styles.dart';
import 'package:voices_dating/net/dio.client.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:voices_dating/entity/ret_entity.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:voices_dating/service/token_service.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:voices_dating/image_res/image_res.dart';

class ConfirmPasswordDialog extends StatelessWidget {
  final VoidCallback? onForgotPassword;
  final DioClient dioClient = DioClient.instance;

  ConfirmPasswordDialog({
    this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final obscureText = true.obs;
    final isLoading = false.obs;

    void confirmPassword() async {
      if (passwordController.text.isEmpty) {
        Get.back();
        Get.snackbar('Error', 'Please enter your password');
        return;
      }

      Get.back();
      isLoading.value = true;

      try {
        await dioClient.requestNetwork<RetEntity>(
          options: Options(headers: {'token': await TokenService.instance.getToken()}),
          method: Method.post,
          url: ApiConstants.confirmPassword,
          params: {'password': passwordController.text},
          onSuccess: (data) {
            isLoading.value = false;
            if (data?.ret == true) {
              // 传递密码到 delete_account 界面
              Get.toNamed(
                AppRoutes.meSettingsDeleteAccount,
                arguments: {'password': passwordController.text},
              );
            }
          },
          onError: (int code, String msg, dynamic data) {
            isLoading.value = false;
            LogUtil.e(msg);
            Get.snackbar(ConstantData.failedText, msg);
          },
        );
      } catch (e) {
        isLoading.value = false;
        LogUtil.e(e.toString());
        Get.snackbar(ConstantData.errorText, e.toString());
      }
    }

    return Dialog(
      backgroundColor: Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 335.w,
          maxHeight: 500.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Confirm Password',
                style: ConstantStyles.customDialogTitle,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(() => Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: obscureText.value,
                  style: TextStyle(fontSize: 16.sp, height: 22 / 18, letterSpacing: 2.0),
                  decoration: InputDecoration(
                    hintText: ConstantData.enterPasswordText,
                    hintStyle: ConstantStyles.enterEmailTextStyle,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    suffixIcon: IconButton(
                      icon: Image.asset(
                        obscureText.value ? ImageRes.iconInvisiblePath : ImageRes.iconVisiblePath,
                        width: 24.w,
                        height: 24.h,
                      ),
                      onPressed: () => obscureText.toggle(),
                    ),
                    isCollapsed: true,
                  ),
                ),
              )),
            ),
            SizedBox(height: 20.h),
            if (onForgotPassword != null)
              TextButton(
                child: Text(
                  'Forgot Password?',
                  style: ConstantStyles.backButtonTextStyle.copyWith(decoration: TextDecoration.underline),
                ),
                onPressed: onForgotPassword,
              ),
            SizedBox(height: 20.h),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CupertinoButton(
                      child: Text(ConstantData.cancelText, style: ConstantStyles.gradientButtonTextStyle.copyWith(color: Colors.red)),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                  ),
                  Container(
                    width: 0.5,
                    height: 49.h,
                    color: Colors.grey.shade300,
                  ),
                  Expanded(
                    child: CupertinoButton(
                      child: Text('Confirm', style: ConstantStyles.gradientButtonTextStyle),
                      onPressed: confirmPassword,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
