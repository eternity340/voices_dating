import 'package:first_app/pages/pre_login/sign_up/sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../entity/User.dart';
import '../../../constants/constant_data.dart';
import '../../../constants/constant_styles.dart';

class SignUpPage extends StatelessWidget {
  final User user;

  SignUpPage({required this.user});

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.put(SignUpController(user));

    return Scaffold(
      body: Background(
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50.h),
                        Text(
                          ConstantData.nicknameTitle,
                          style: ConstantStyles.formLabelStyle,
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          width: 303.w,
                          child: TextFormField(
                            controller: controller.usernameController,
                            decoration: ConstantStyles.textFieldDecoration,
                            style: ConstantStyles.textFieldStyle,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a username";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          ConstantData.passwordTitle,
                          style: ConstantStyles.formLabelStyle,
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: 303.w,
                          child: TextFormField(
                            controller: controller.passwordController,
                            decoration: ConstantStyles.textFieldDecoration,
                            obscureText: true,
                            style: ConstantStyles.textFieldStyle,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a password";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 150.h),
                        Center(
                          child: Obx(() => GradientButton(
                            text: ConstantData.submitButtonText,
                            onPressed: controller.isLoading.value ? null : () => controller.signUp(),
                            width: 200.w,
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
