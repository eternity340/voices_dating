import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../constants/constant_styles.dart';
import '../../../constants/constant_data.dart';  // Import the constants file
import '../model/verify_email_model.dart';
import '../provider/verify_email_provider.dart';
import '../components/verify_code_input.dart';  // 更新导入

class VerifyEmailPage extends StatefulWidget {
  final String email;
  final String verificationKey;

  VerifyEmailPage({required this.email, required this.verificationKey});

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late Timer _timer;
  int _start = 30;
  bool _isResendButtonVisible = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _isResendButtonVisible = false;
    _start = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendButtonVisible = true;
        });
        _timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VerifyEmailProvider(
      email: widget.email,
      verificationKey: widget.verificationKey,
      child: Scaffold(
        body: Background(
          child: Padding(
            padding: EdgeInsets.all(16.0.w), // Use responsive padding
            child: Consumer<VerifyEmailModel>(
              builder: (context, model, child) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 100.h), // Use responsive height
                      Center(
                        child: Text(
                          ConstantData.verifyCodeTitle,
                          textAlign: TextAlign.center,
                          style: ConstantStyles.verifyCodeTitle,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0.w), // Use responsive padding
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
                          model.codeController.text = value;
                        },
                      ),
                      SizedBox(height: 20.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _isResendButtonVisible
                            ? Container()  // Hide timer text when _isResendButtonVisible is true
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
                            // Resend verification code logic
                            startTimer();
                          },
                          child: Text(
                            ConstantData.resendCode,
                            style: ConstantStyles.resendButtonText,
                          ),
                        ),
                      )
                          : Container(),
                      SizedBox(height: 300.h), // Use responsive height
                      model.isLoading
                          ? CircularProgressIndicator()
                          : Center(
                        child: GradientButton(
                          text: ConstantData.verifyButtonText,
                          onPressed: model.verifyEmail,
                          width: 200.w, // Use responsive width
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
