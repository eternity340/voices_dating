import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/gradient_btn.dart';
import '../../../components/select_box.dart';
import '../../../entity/User.dart';
import '../../../components/background.dart';
import '../../../constants/constant_data.dart';
import '../../../constants/constant_styles.dart';

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
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100.h),
                Text(
                  ConstantData.genderTitle,
                  style: ConstantStyles.genderTitleStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 34.h),
                SelectBox(
                  text: ConstantData.maleOption,
                  isSelected: selectedGender == "2",
                  onTap: () {
                    setState(() {
                      selectedGender = "2";
                    });
                  },
                ),
                SizedBox(height: 20.h),
                SelectBox(
                  text: ConstantData.femaleOption,
                  isSelected: selectedGender == "1",
                  onTap: () {
                    setState(() {
                      selectedGender = "1";
                    });
                  },
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ConstantData.genderWarning,
                    style: ConstantStyles.genderWarningStyle,
                  ),
                ),
                SizedBox(height: 180.h),
                GradientButton(
                  text: ConstantData.continueButtonText,
                  onPressed: () {
                    if (selectedGender != null) {
                      widget.user.gender = selectedGender;
                      Get.toNamed('/select_location', arguments: widget.user);
                    }
                  },
                  width: 200.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
