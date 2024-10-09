import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/background.dart';
import '../../../responsive.dart';
import 'components/sign_form.dart';
import 'components/sign_screen_top_image.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: buildMobileSignInScreen(),
          desktop: buildDesktopSignInScreen(),
        ),
      ),
    );
  }

  Widget buildMobileSignInScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SignScreenTopImage(),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SignForm(),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget buildDesktopSignInScreen() {
    return Row(
      children: [
        const Expanded(
          child: SignScreenTopImage(),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 450.w,
                child: SignForm(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
