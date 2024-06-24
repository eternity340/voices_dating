import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../entity/User.dart';
import '../components/gradient_btn.dart';


class SelectBirthdayPage extends StatelessWidget {
  final User user;

  SelectBirthdayPage({required this.user});

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Birthday"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Select your birthday",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null && pickedDate != selectedDate)
                    selectedDate = pickedDate;
                },
                child: Text("Select Date"),
              ),
              SizedBox(height: 20),
              GradientButton(
                text: "Continue",
                onPressed: () {
                  user.birthday = selectedDate;
                  Get.toNamed('/profile_summary', arguments: user);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
