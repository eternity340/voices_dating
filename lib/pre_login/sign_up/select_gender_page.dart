import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/gradient_btn.dart';
import '../../components/select_box.dart';
import '../../entity/User.dart';
import '../../components/background.dart';


class SelectGenderPage extends StatefulWidget {
  final User user;

  SelectGenderPage({required this.user});

  @override
  _SelectGenderPageState createState() => _SelectGenderPageState();
}

class _SelectGenderPageState extends State<SelectGenderPage> {
  String? selectedGender;

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
                SizedBox(height: 100),
                const Text(
                  "Gender",
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
                SizedBox(height: 34),
                SelectBox(
                  text: "Male",
                  isSelected: selectedGender == "Male",
                  onTap: () {
                    setState(() {
                      selectedGender = "Male";
                    });
                  },
                ),
                SizedBox(height: 20),
                SelectBox(
                  text: "Female",
                  isSelected: selectedGender == "Female",
                  onTap: () {
                    setState(() {
                      selectedGender = "Female";
                    });
                  },
                ),
                SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft, // 对齐方式设置为左对齐
                  child: Text(
                    "Gender cannot be changed after selection",
                    style: TextStyle(
                      fontSize: 14,
                      height: 24 / 14,
                      letterSpacing: -0.01,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
                SizedBox(height: 300),
                GradientButton(
                  text: "Continue",
                  onPressed: () {
                    if (selectedGender != null) {
                      widget.user.gender = selectedGender!;
                      Get.toNamed('/select_location', arguments: widget.user);
                    }
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
