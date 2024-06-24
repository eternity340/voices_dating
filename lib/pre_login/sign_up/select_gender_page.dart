import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../entity/User.dart';
import '../../../constants.dart';
import '../components/gradient_btn.dart';

class SelectGenderPage extends StatelessWidget {
  final User user;

  SelectGenderPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Gender"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Select your gender",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              GradientButton(
                text: "Male",
                onPressed: () {
                  user.gender = "Male";
                  Get.toNamed('/select_location', arguments: user);
                },
              ),
              SizedBox(height: 20),
              GradientButton(
                text: "Female",
                onPressed: () {
                  user.gender = "Female";
                  Get.toNamed('/select_location', arguments: user);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
