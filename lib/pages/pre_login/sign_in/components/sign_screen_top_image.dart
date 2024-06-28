import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../constants.dart';

class SignScreenTopImage extends StatelessWidget {
  const SignScreenTopImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height:60),
        Text(
          "Sign In",
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

      ],
    );
  }
}
