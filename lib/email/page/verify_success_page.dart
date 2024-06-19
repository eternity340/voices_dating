import 'package:flutter/material.dart';
import 'package:get/get.dart';
class VerifySuccessPage extends StatelessWidget {
  final String message;

  VerifySuccessPage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("验证成功"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                "邮箱验证成功！",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                message.isEmpty ? "您的邮箱已成功验证。" : message,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to home or any other page
                  Get.offAllNamed('/'); // 假设 '/' 是你的主页路由
                },
                child: Text("返回首页"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
