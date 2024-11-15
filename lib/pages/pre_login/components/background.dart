import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../image_res/image_res.dart';

class Background extends StatelessWidget {
  final Widget child;
  final String topImage, bottomImage;

  const Background({
    super.key,
    required this.child,
    this.topImage = ImageRes.imagePathMainTop,
    this.bottomImage = ImageRes.imagePathLoginBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                topImage,
                width: 120.w, // Use ScreenUtil to set the width
              ),
            ),
            // 如果你希望在底部也显示一个图片，可以取消注释下面的代码
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                bottomImage,
                width: 120.w, // Use ScreenUtil to set the width
              ),
            ),
            SafeArea(child: child),
          ],
        ),
      ),
    );
  }
}
