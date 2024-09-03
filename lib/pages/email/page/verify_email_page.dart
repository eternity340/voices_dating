import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../constants/constant_styles.dart';
import '../../../constants/constant_data.dart';
import '../components/verify_code_input.dart';
import '../controller/verify_email_controller.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;
  final String verificationKey;

  VerifyEmailPage({required this.email, required this.verificationKey});

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late VerifyEmailController controller;
  late Timer timer;
  int _start = 60;
  bool _isResendButtonVisible = false;

  @override
  void initState() {
    super.initState();
    controller =
        Get.put(VerifyEmailController(
            email: widget.email,
            verificationKey: widget.verificationKey));
    startTimer();
  }

  void startTimer() {
    setState(() {
      _isResendButtonVisible = false;
      _start = 60;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendButtonVisible = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.h),
                Center(
                  child: Text(
                    ConstantData.verifyCodeTitle,
                    textAlign: TextAlign.center,
                    style: ConstantStyles.verifyCodeTitle,
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 16.0.w),
                  child: Text(
                    ConstantData.verifyCodeSubtitle,
                    textAlign: TextAlign.start,
                    style: ConstantStyles.verifyCodeSubtitle,
                  ),
                ),
                SizedBox(height: 20.h),
                VerifyCodeInput(
                  length: 6,
                  onCompleted: (String value) {
                    controller.codeController.text = value;
                  },
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: _isResendButtonVisible
                      ? Container()
                      : Text(
                    '$_start ${ConstantData.timerText}',
                    style: ConstantStyles.timerText,
                  ),
                ),
                SizedBox(height: 20.h),
                _isResendButtonVisible
                    ? Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      //controller.resendVerificationCode();
                      startTimer();
                    },
                    child: Text(
                      ConstantData.resendCode,
                      style: ConstantStyles.resendButtonText,
                    ),
                  ),
                )
                    : Container(),
                SizedBox(height: 250.h),
                Obx(() => controller.isLoading.value
                    ? CircularProgressIndicator()
                    : Center(
                  child: GradientButton(
                    text: ConstantData.verifyButtonText,
                    onPressed: controller.verifyEmail,
                    width: 200.w,
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
