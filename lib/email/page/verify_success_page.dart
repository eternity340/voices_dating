import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../entity/User.dart';

class VerifySuccessPage extends StatelessWidget {
  final String message;
  final User user;

  VerifySuccessPage({required this.message, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification Success"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100,
              ),
              SizedBox(height: 20),
              const Text(
                "Email verification successful！",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                message.isEmpty ? "Your email has been successfully verified." : message,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/select_gender', arguments: user);
                },
                child: Text("Select Gender"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
