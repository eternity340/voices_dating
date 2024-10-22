import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../constants/constant_styles.dart';
import '../../../constants/constant_data.dart';
import '../../../utils/common_utils.dart';
import '../components/verify_code_input.dart';
import '../controller/verify_email_controller.dart';
import '../controller/get_email_code_controller.dart'; // 添加这行

class VerifyEmailPage extends StatefulWidget {
  final String email;
  final String verificationKey;

  VerifyEmailPage({required this.email, required this.verificationKey});

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late VerifyEmailController controller;
  late GetEmailCodeController getEmailCodeController; // 添加这行
  late Timer timer;
  int _start = 10;
  bool _isResendButtonVisible = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VerifyEmailController(
        email: widget.email,
        verificationKey: widget.verificationKey));
    getEmailCodeController = Get.find<GetEmailCodeController>(); // 添加这行
    startTimer();
  }

  void startTimer() {
    setState(() {
      _isResendButtonVisible = false;
      _start = 10;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(child: SizedBox()),
                    SizedBox(
                      width: 120.w,
                      height: 40.h,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        layoutBuilder: (currentChild, previousChildren) {
                          return Stack(
                            alignment: Alignment.centerRight,
                            children: <Widget>[
                              ...previousChildren,
                              if (currentChild != null) currentChild,
                            ],
                          );
                        },
                        child: _isResendButtonVisible
                            ? TextButton(
                          key: ValueKey<bool>(true),
                          onPressed: () async {
                            await getEmailCodeController.sendVerificationCode();
                            startTimer();
                          },
                          child: Text(
                            ConstantData.resendCode,
                            style: ConstantStyles.resendButtonText,
                          ),
                        )
                            : Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '$_start ${ConstantData.timerText}',
                            key: ValueKey<bool>(false),
                            style: ConstantStyles.timerText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 250.h),
                Obx(() => controller.isLoading.value
                    ? CommonUtils.loadingIndicator(
                  color: Colors.black,
                  radius: 15.0,
                )
                    : Center(
                  child: GradientButton(
                    text: ConstantData.verifyButtonText,
                    onPressed: () {
                      controller.verifyEmail();
                    },
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
