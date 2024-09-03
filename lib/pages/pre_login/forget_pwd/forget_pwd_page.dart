import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import 'forget_pwd_controller.dart';

class ForgetPwdPage extends StatelessWidget {
  const ForgetPwdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ForgetPwdController controller = Get.put(ForgetPwdController());

    return Scaffold(
      body: Stack(
        children: [
          Background(child: Container()),
          Positioned(
            left: 200.w,
            top: 59.h,
            child: SizedBox(
              width: 157.w,
              height: 80.h,
              child: Text(
                "Forget password",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28.w,
                  fontWeight: FontWeight.bold,
                  height: 44 / 32,
                  letterSpacing: -0.02,
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20.w,
            right: 20.w,
            top: 200.h,
            child: TextField(
              controller: controller.emailController,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                height: 1.2,
                letterSpacing: 0,
                color: Colors.black,
              ),
              cursorColor: Color(0xFF20E2D7),
              decoration: InputDecoration(
                labelText: "Enter your email",
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEBEBEB)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEBEBEB)),
                ),
                filled: true,
                fillColor: Colors.transparent,
                floatingLabelStyle: TextStyle(color: Color(0xFF20E2D7)),
                contentPadding: EdgeInsets.only(bottom: 4.h),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Positioned(
            left: 60.w,
            right: 60.w,
            top: 680.h,
            child: Obx(() => GradientButton(
              text: "Send",
              onPressed: controller.isLoading ? null : () => controller.sendResetEmail(),
              /*child: controller.isLoading
                  ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : null,*/
            )),
          ),
          Positioned(
            left: 20.w,
            right: 20.w,
            top: 440.h,
            child: Obx(() => controller.errorMessage.isNotEmpty
                ? Text(
              controller.errorMessage,
              style: const TextStyle(color: Colors.red),
            )
                : const SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}
