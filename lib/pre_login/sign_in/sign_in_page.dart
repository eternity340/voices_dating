import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../responsive.dart';
import '../components/background.dart';
import 'sign_in_model.dart';
import 'components/sign_form.dart';
import 'components/sign_screen_top_image.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileSignInScreen(),
          desktop: Row(
            children: [
              Expanded(
                child: SignScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: SignForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileSignInScreen extends StatelessWidget {
  const MobileSignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SignScreenTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: SignForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
