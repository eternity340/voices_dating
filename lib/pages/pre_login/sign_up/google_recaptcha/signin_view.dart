/*
import 'package:first_app/net/api_constants.dart';
import 'package:first_app/pages/pre_login/sign_up/google_recaptcha/signin_view_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SigninPageLogic());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        child: Container(
          color: Get.theme.primaryColor,
          child: Column(
            children: [
          Container(
            height: 58.h,
            width: 1.sw,
            margin: EdgeInsets.only(left: 37.w, top: 59.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Image.asset(
                    'images/signIn/arrow_backward.png',
                    width: 24.w,
                    height: 25.h,
                  ),
                ),
                SizedBox(
                  width: 9.w,
                  height: 1.h,
                ),
                Obx(() => Expanded(
                      child: Text(
                        controller.defaultPageTitle.value,
                        style: TextStyle(
                            fontSize: 24.sp,
                            color: controller.errorPageText.value,
                            fontWeight: FontWeight.bold),
                      ),
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 36.h,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.sp),
                      topRight: Radius.circular(20.sp))),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 28.w, top: 60.h, bottom: 30.h, right: 28.w),
                        child: Column(
                          children: [
                            TextField(
                              onTapOutside: (event) {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                currentFocus.focusedChild?.unfocus();
                              },
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                controller.email = value;
                              },
                              decoration: const InputDecoration(
                                  labelText: "Email",
                                  prefixIcon: Icon(Icons.email)),
                            ),
                            SizedBox(height: 26.h),

                            Obx(() => TextField(
                                  onTapOutside: (event) {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    currentFocus.focusedChild?.unfocus();
                                  },
                                  keyboardType: TextInputType.text,
                                  obscureText: controller.passWord.value,
                                  onChanged: (value) {
                                    controller.password = value;
                                  },
                                  decoration: InputDecoration(
                                      labelText: "PassWord",
                                      prefixIcon: const Icon(Icons.password),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          controller.passWord.value =
                                              !controller.passWord.value;
                                        },
                                        icon: controller.passWord.value
                                            ? const Icon(Icons.visibility_off)
                                            : const Icon(Icons.visibility),
                                      )),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 140.w,
                        height: 60.h,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor)),
                          onPressed: () {
                            //登录
                            //controller.login();
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(left: 70.w),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                //忘记密码
                                Get.toNamed(ApiConstants.forgetPassword);
                              },
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color.fromARGB(
                                        255, 0x24, 0x2A, 0x37)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 24.w, right: 23.w),
                              width: 1.w,
                              height: 21.h,
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                      255, 0x97, 0x97, 0x97),
                                  border: Border.all(width: 1.w)),
                            ),
                            GestureDetector(
                              onTap: () {
                                //寻求帮助
                              },
                              child: Text(
                                "Help",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color.fromARGB(
                                        255, 0x24, 0x2A, 0x37)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
