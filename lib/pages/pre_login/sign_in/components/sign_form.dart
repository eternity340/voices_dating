import 'package:voices_dating/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../components/gradient_btn.dart';
import '../../../../components/no_underline_input_field.dart';
import '../../../../constants.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import '../../../../image_res/image_res.dart';
import '../sign_in_model.dart';
import 'package:get/get.dart' as getx;

class SignForm extends StatelessWidget {
  const SignForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SignInModel>(context);

    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50.h),
          NoUnderlineInputField(
            label: ConstantData.enterYourEmail,
            isEmail: true,
            controller: model.emailController,
          ),
          SizedBox(height: 20.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ConstantData.enterPasswordText,
                style: ConstantStyles.passwordTextStyle,
              ),
              SizedBox(height: 8.h),
              Container(
                width: 303.w,
                child: TextFormField(
                  controller: model.passwordController,
                  textInputAction: TextInputAction.done,
                  obscureText: !model.isPasswordVisible,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
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
                    suffixIcon: IconButton(
                      icon: Image.asset(
                        model.isPasswordVisible
                            ? ImageRes.iconVisiblePath
                            : ImageRes.iconInvisiblePath,
                        width: 24,
                        height: 24,
                      ),
                      onPressed: model.togglePasswordVisibility,
                    ),
                  ),
                  style: ConstantStyles.inputTextStyle,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  getx.Get.toNamed(AppRoutes.preFeedback);
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: const Text(
                  ConstantData.forgetPassword,
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 200.h),
          Center(
            child: GradientButton(
              text: "SUBMIT",
              onPressed: model.isLoading ? (){} : () => model.signIn(),
            ),
          ),
        ],
      ),
    );
  }
}
