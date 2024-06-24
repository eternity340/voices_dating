import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import '../../../constants.dart';

class SignBtn extends StatelessWidget {
  const SignBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            getx.Get.toNamed('/sign_in');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF20E2D7), Color(0xFFD8FAAD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                "SIGN IN".toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,  // 设置字体颜色为黑色
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity, // 扩展以填充可用空间
          child: OutlinedButton(
            onPressed: () {
              getx.Get.toNamed('/get_mail_code');
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black, width: 2.0),  // 设置边框颜色为黑色，并加粗为 2.0
              backgroundColor: Colors.transparent,  // 设置背景颜色为透明
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),  // 设置圆角半径
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12), // 调整垂直内边距
              child: Text(
                "Sign Up".toUpperCase(),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
