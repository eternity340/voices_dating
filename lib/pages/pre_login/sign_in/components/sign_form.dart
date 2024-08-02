import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../components/gradient_btn.dart';
import '../../../../constants.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
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
          Text(
            ConstantData.enterYourEmail,
            style: ConstantStyles.signEmailTextStyle,
          ),
          SizedBox(height: 20.h),
          Container(
            width: 303.w,
            child: TextFormField(
              controller: model.emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: null,
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1),
                ),
              ),
              style: ConstantStyles.inputTextStyle,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a valid email";
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            ConstantData.enterPasswordText,
            style: ConstantStyles.passwordTextStyle,
          ),
          SizedBox(height: 10.h),
          Container(
            width: 303.w,
            child: TextFormField(
              controller: model.passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: null,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1),
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
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  getx.Get.toNamed('/forget_pwd');
                },
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
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
              text: "Submit",
              onPressed: model.isLoading ? (){} : () => model.signIn(),
            ),
          ),
        ],
      ),
    );
  }
}
