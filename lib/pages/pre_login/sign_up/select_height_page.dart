import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../entity/User.dart';
import '../../../components/gradient_btn.dart';
import '../../../components/background.dart';
import 'components/height_picker.dart';

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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                const Text(
                  "Height",
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
                SizedBox(height: 170),
                GradientButton(
                  text: "Continue",
                  onPressed: () {
                    widget.user.height = selectedHeight.toString();
                    Get.toNamed('/sign_up', arguments: widget.user);
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


