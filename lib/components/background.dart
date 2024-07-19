import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                'assets/icons/bg.svg',
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
                              'assets/images/back.png',
                              width: 24.w,
                              height: 24.h,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Back',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 14.sp,
                                color: Colors.black,
                                letterSpacing: 2.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (showMiddleText && middleText != null)
                    Positioned(
                      top: 8.h,
                      left: MediaQuery.of(context).size.width / 2 - 50.w,
                      child: Text(
                        middleText!,
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          height: 22 / 18,
                          color: Colors.black,
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
                            'Save',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (showSettingButton)
                    Positioned(
                      top: 8.h,
                      right: 16.w,
                      child: GestureDetector(
                        onTap: () {
                          // 处理设置按钮点击事件
                        },
                        child: Image.asset(
                          'assets/images/button_round_setting.png',
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
