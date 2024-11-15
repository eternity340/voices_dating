import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voices_dating/pages/pre_login/components/sign_btn.dart';
import 'package:voices_dating/pages/pre_login/welcome/components/welcome_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import '../../../responsive.dart';
import '../components/background.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Background(
        child: SafeArea(
          child: Responsive(
            desktop: Row(
              children: [
                WelcomeImage(),
                SignBtn(),
              ],
            ),
            mobile: MobileWelcomeScreen(),
          ),
      ),
    );
  }
}

class MobileWelcomeScreen extends StatelessWidget {
  const MobileWelcomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        WelcomeImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: SignBtn(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}