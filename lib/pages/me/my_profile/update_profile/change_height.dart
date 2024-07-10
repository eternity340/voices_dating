import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../entity/User.dart';
import '../../../../components/gradient_btn.dart';
import '../../../../components/background.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../../../pre_login/sign_up/components/height_picker.dart';

class ChangeHeight extends StatefulWidget {
  final tokenEntity = Get.arguments['token'] as TokenEntity;
  final userData = Get.arguments['userData'] as UserDataEntity;

  @override
  _ChangeHeightState createState() => _ChangeHeightState();
}

class _ChangeHeightState extends State<ChangeHeight> {

  int selectedHeight = 170; // Default height

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        showBackgroundImage: false,
        showActionButton: true,
        showMiddleText: true,
        middleText: 'Height',
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 100),
                const Text(
                  "Change Height",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Poppins'), // Use appropriate font family here
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                HeightPicker(
                  initialHeight: selectedHeight,
                  onHeightChanged: (newHeight) {
                    setState(() {
                      selectedHeight = newHeight;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
