import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/gradient_btn.dart';
import '../../../components/select_box.dart';
import '../../../entity/User.dart';
import '../../../components/background.dart';
import '../../../constants/constant_data.dart'; // Import constant data
import '../../../constants/constant_styles.dart'; // Import constant styles

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
            padding: EdgeInsets.all(16.0.w), // Responsive padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100.h), // Responsive height
                Text(
                  ConstantData.genderTitle,
                  style: ConstantStyles.genderTitleStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 34.h), // Responsive height
                SelectBox(
                  text: ConstantData.maleOption,
                  isSelected: selectedGender == ConstantData.maleOption,
                  onTap: () {
                    setState(() {
                      selectedGender = ConstantData.maleOption;
                    });
                  },
                ),
                SizedBox(height: 20.h), // Responsive height
                SelectBox(
                  text: ConstantData.femaleOption,
                  isSelected: selectedGender == ConstantData.femaleOption,
                  onTap: () {
                    setState(() {
                      selectedGender = ConstantData.femaleOption;
                    });
                  },
                ),
                SizedBox(height: 20.h), // Responsive height
                Align(
                  alignment: Alignment.centerLeft, // Left alignment
                  child: Text(
                    ConstantData.genderWarning,
                    style: ConstantStyles.genderWarningStyle,
                  ),
                ),
                SizedBox(height: 180.h), // Responsive height
                GradientButton(
                  text: ConstantData.continueButtonText,
                  onPressed: () {
                    if (selectedGender != null) {
                      widget.user.gender = selectedGender!;
                      Get.toNamed('/select_location', arguments: widget.user);
                    }
                  },
                  width: 200.w, // Responsive width
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
