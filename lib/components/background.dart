import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/constant_styles.dart';
import '../constants/constant_data.dart';
import '../image_res/image_res.dart';

class Background extends StatelessWidget {
  final Widget child;
  final bool showBackButton;
  final bool showSettingButton;
  final bool showBackgroundImage;
  final String? middleText;
  final bool showMiddleText;
  final bool showActionButton;

  const Background({
    Key? key,
    required this.child,
    this.showBackButton = true,
    this.showSettingButton = false,
    this.showBackgroundImage = true,
    this.middleText,
    this.showMiddleText = false,
    this.showActionButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          if (showBackgroundImage)
            Positioned.fill(
              child: SvgPicture.asset(
                ImageRes.imagePathBackground,
                fit: BoxFit.fill,
              ),
            ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8.h,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Stack(
                children: [
                  child,
                  if (showBackButton)
                    Positioned(
                      top: 8.h,
                      left: 16.w,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              ImageRes.imagePathBackButton,
                              width: 24.w,
                              height: 24.h,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              ConstantData.backText,
                              style: ConstantStyles.backButtonTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (showMiddleText && middleText != null)
                    Positioned(
                      top: 8.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          middleText!,
                          style: ConstantStyles.middleTextStyle,
                        ),
                      ),
                    ),
                  if (showActionButton)
                    Positioned(
                      top: 4.h,
                      right: 16.w,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        transform: Matrix4.translationValues(-8.w, 0, 0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFFD6FAAE), Color(0xFF20E2D7)],
                          ),
                          borderRadius: BorderRadius.circular(24.5.r),
                        ),
                        width: 88.w,
                        height: 36.h,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            ConstantData.saveText,
                            style: ConstantStyles.actionButtonTextStyle,
                          ),
                        ),
                      ),
                    ),
                  if (showSettingButton)
                    Positioned(
                      top: 0.h,
                      right: 16.w,
                      child: GestureDetector(
                        onTap: () {
                          // 添加您的设置按钮操作
                        },
                        child: Image.asset(
                          ImageRes.imagePathSettingButton,
                          width: 40.w,
                          height: 40.h,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}