import 'package:first_app/constants/constant_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../constants.dart';
import '../../../../constants/Constant_styles.dart';

class SignScreenTopImage extends StatelessWidget {
  const SignScreenTopImage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        SizedBox(height:60),
        Text(
          ConstantData.signInText,
          style: ConstantStyles.signInTextStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 34),

      ],
    );
  }
}
