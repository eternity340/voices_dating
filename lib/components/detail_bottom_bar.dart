import 'dart:ui';
import 'package:first_app/entity/moment_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../pages/moments/components/love_button.dart';
import 'gradient_btn.dart';
import '../../../entity/token_entity.dart';

class DetailBottomBar extends StatefulWidget {
  final String gradientButtonText;
  final VoidCallback onGradientButtonPressed;
  final bool showCallButton;
  final bool showMessageButton;
  final bool showMomentLikeButton;
  final MomentEntity? moment; // Made optional
  final TokenEntity? tokenEntity; // Made optional

  DetailBottomBar({
    required this.gradientButtonText,
    required this.onGradientButtonPressed,
    this.moment,
    this.tokenEntity,
    this.showCallButton = true,
    this.showMessageButton = true,
    this.showMomentLikeButton = true, 
  });

  @override
  _DetailBottomBarState createState() => _DetailBottomBarState();
}

class _DetailBottomBarState extends State<DetailBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      width: 375.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: Color(0x5CD4D7E0),
            offset: Offset(0, -20.h),
            blurRadius: 30.w,
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 89.76, sigmaY: 89.76),
          child: Stack(
            children: [
              if (widget.showCallButton)
                Positioned(
                  left: 42.w,
                  top: 14.h,
                  child: Image.asset(
                    'assets/images/icon_call.png',
                    width: 24.w,
                    height: 43.5.h,
                  ),
                ),
              if (widget.showMessageButton)
                Positioned(
                  left: 100.w,
                  top: 14.h,
                  child: Image.asset(
                    'assets/images/icon_message.png',
                    width: 24.w,
                    height: 43.5.h,
                  ),
                ),
              if (widget.showMomentLikeButton && widget.moment!= null && widget.tokenEntity != null)
                Positioned(
                  left: 52.w,
                  top: 10.h,
                  child: Column(
                    children: [
                      LoveButton(

                        tokenEntity: widget.tokenEntity!, moment: widget.moment!,
                      ),
                      Text(
                        'like',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              Positioned(
                left: 150.w,
                top: 12.h,
                child: GradientButton(
                  text: widget.gradientButtonText,
                  onPressed: widget.onGradientButtonPressed,
                  width: 177.w,
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
