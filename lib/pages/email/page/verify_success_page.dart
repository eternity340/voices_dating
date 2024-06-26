import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../entity/User.dart';

class VerifySuccessPage extends StatelessWidget {
  final String message;
  final User user;

  VerifySuccessPage({required this.message, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Email verification successful！",
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    height: 44 / 32,
                    letterSpacing: -0.02,
                    color: Color(0xFF000000),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  message.isEmpty ? "Your email has been successfully verified." : message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8E8E93),
                    letterSpacing: 2.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 300),
                GradientButton(
                  text: "Next",
                  onPressed: () {
                    Get.toNamed('/select_gender', arguments: user);
                  },
                  width: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
