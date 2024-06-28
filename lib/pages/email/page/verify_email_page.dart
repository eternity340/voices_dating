import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
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
            padding: const EdgeInsets.all(16.0),
            child: Consumer<VerifyEmailModel>(
              builder: (context, model, child) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100),
                      const Center(
                        child: Text(
                          "Verify Code",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            height: 44 / 32,
                            letterSpacing: -0.02,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Enter the verify code sent to your email",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8E8E93),
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      VerifyCodeInput(
                        length: 6,
                        onCompleted: (String value) {
                          model.codeController.text = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _isResendButtonVisible
                            ? Container()  // 当 _isResendButtonVisible 为 true 时隐藏计时器文本
                            : Text(
                          '$_start s resend code',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF8E8E93),
                            height: 24 / 14,
                            letterSpacing: -0.01,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _isResendButtonVisible
                          ? Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // 重新发送验证码的逻辑
                            startTimer();
                          },
                          child: const Text(
                            'Resend Code',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF2FE4D4),
                              height: 24 / 14,
                              letterSpacing: -0.01,
                            ),
                          ),
                        ),
                      )
                          : Container(),
                      const SizedBox(height: 300), // 调整间距
                      model.isLoading
                          ? const CircularProgressIndicator()
                          : Center(
                        child: GradientButton(
                          text: "Verify",
                          onPressed: model.verifyEmail,
                          width: 200,
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
