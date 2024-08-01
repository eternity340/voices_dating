import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../entity/User.dart';
import '../../../components/gradient_btn.dart';
import '../../../components/background.dart';
import 'components/height_picker.dart';
import '../../../constants/constant_data.dart'; // Import constant data
import '../../../constants/constant_styles.dart'; // Import constant styles

class SelectHeightPage extends StatefulWidget {
  final User user;

  SelectHeightPage({required this.user});

  @override
  _SelectHeightPageState createState() => _SelectHeightPageState();
}

class _SelectHeightPageState extends State<SelectHeightPage> {
  int selectedHeight = 170; // Default height

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SingleChildScrollView( // Make content scrollable
          child: Padding(
            padding: EdgeInsets.all(80.0.w), // Responsive padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50.h), // Responsive height
                Text(
                  ConstantData.heightTitle,
                  style: ConstantStyles.heightTitleStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50.h), // Responsive height
                HeightPicker(
                  initialHeight: selectedHeight,
                  onHeightChanged: (newHeight) {
                    setState(() {
                      selectedHeight = newHeight;
                    });
                  },
                ),
                SizedBox(height: 120.h), // Responsive height
                GradientButton(
                  text: ConstantData.continueButtonText,
                  onPressed: () {
                    widget.user.height = selectedHeight.toString();
                    Get.toNamed('/sign_up', arguments: widget.user);
                  },
                  width: 200.w, // Responsive width
                ),
                SizedBox(height: 50.h), // Add some space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
