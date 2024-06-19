import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants.dart';

class SignScreenTopImage extends StatelessWidget {
  const SignScreenTopImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "LOGIN",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SvgPicture.asset(
                "assets/icons/login.svg", // 替换为您的登录图像路径
                height: 200,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
