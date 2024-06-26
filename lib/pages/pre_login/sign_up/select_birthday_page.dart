import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../entity/User.dart';
import '../../../components/gradient_btn.dart';
import '../../../components/background.dart';

class SelectBirthdayPage extends StatefulWidget {
  final User user;

  SelectBirthdayPage({required this.user});

  @override
  _SelectBirthdayPageState createState() => _SelectBirthdayPageState();
}

class _SelectBirthdayPageState extends State<SelectBirthdayPage> {
  DateTime selectedDate = DateTime.now();

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
                SizedBox(height: 50),
                const Text(
                  "Birthday",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _buildDatePicker(context),
                SizedBox(height: 20),
                GradientButton(
                  text: "Continue",
                  onPressed: () {
                    widget.user.birthday = selectedDate;
                    Get.toNamed('/profile_summary', arguments: widget.user);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null && pickedDate != selectedDate) {
            setState(() {
            selectedDate = pickedDate;
          });
        }
      },
      child: Text("Select Date"),
    );
  }
}
