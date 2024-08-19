
import 'package:first_app/pages/pre_login/sign_in/components/sign_form.dart';
import 'package:first_app/pages/pre_login/sign_in/components/sign_screen_top_image.dart';
import 'package:flutter/cupertino.dart';

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