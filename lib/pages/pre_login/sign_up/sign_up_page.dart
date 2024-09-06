import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../entity/User.dart';
import '../../../constants/constant_data.dart';
import '../../../constants/constant_styles.dart';
import '../../../image_res/image_res.dart';
import 'sign_up_controller.dart';

class SignUpPage extends StatelessWidget {
  final User user;

  SignUpPage({Key? key, required this.user}) : super(key: key);

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
                        _buildUsernameField(controller),
                        SizedBox(height: 20.h),
                        _buildPasswordField(controller),
                        SizedBox(height: 20.h),
                        _buildConfirmPasswordField(controller),
                        _buildConfirmPasswordErrorMessage(controller),
                        SizedBox(height: 150.h),
                        _buildSubmitButton(controller),
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

  Widget _buildUsernameField(SignUpController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            onChanged: (value) => controller.setUsername(value),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(SignUpController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ConstantData.passwordTitle,
          style: ConstantStyles.formLabelStyle,
        ),
        SizedBox(height: 10.h),
        Container(
          width: 303.w,
          child: Obx(() => TextFormField(
            controller: controller.passwordController,
            decoration: _getPasswordDecoration(controller),
            obscureText: !controller.isPasswordVisible.value,
            style: ConstantStyles.textFieldStyle,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a password";
              }
              return null;
            },
            onChanged: (value) => controller.setPassword(value),
          )),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField(SignUpController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Confirm Password",
          style: ConstantStyles.formLabelStyle,
        ),
        SizedBox(height: 10.h),
        Container(
          width: 303.w,
          child: Obx(() => TextFormField(
            controller: controller.confirmPasswordController,
            decoration: _getPasswordDecoration(controller, isConfirmPassword: true),
            obscureText: !controller.isConfirmPasswordVisible.value,
            style: ConstantStyles.textFieldStyle,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please confirm your password";
              }
              if (value != controller.passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
            onChanged: (value) => controller.setConfirmPassword(value),
          )),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordErrorMessage(SignUpController controller) {
    return Container(
      height: 20.h,
      child: Obx(() => controller.confirmPasswordErrorMessage.value.isNotEmpty
          ? Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Text(
          controller.confirmPasswordErrorMessage.value,
          style: TextStyle(color: Colors.red, fontSize: 12.sp),
        ),
      )
          : SizedBox.shrink()
      ),
    );
  }


  Widget _buildSubmitButton(SignUpController controller) {
    return Center(
      child: Obx(() => GradientButton(
        text: ConstantData.submitButtonText,
        onPressed: controller.isLoading.value ? null : () => controller.signUp(),
        width: 200.w,
      )),
    );
  }


  InputDecoration _getPasswordDecoration(SignUpController controller, {bool isConfirmPassword = false}) {
    return InputDecoration(
      hintText: null,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1),
      ),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1),
      ),
      suffixIcon: isConfirmPassword
          ? null
          : IconButton(
        icon: Image.asset(
          controller.isPasswordVisible.value
              ? ImageRes.iconVisiblePath
              : ImageRes.iconInvisiblePath,
          width: 24,
          height: 24,
        ),
        onPressed: controller.togglePasswordVisibility,
      ),
    );
  }
}
