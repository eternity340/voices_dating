import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/constant_styles.dart';
import '../../../image_res/image_res.dart';
import '../../../components/gradient_btn.dart';
import '../../../../../entity/token_entity.dart';
import '../constants.dart';
import '../constants/constant_data.dart';

class ProfileBottom extends StatefulWidget {
  final String initialGradientButtonText;
  final VoidCallback onInitialGradientButtonPressed;
  final VoidCallback onCallButtonPressed;
  final VoidCallback onChatButtonPressed;
  final TokenEntity? tokenEntity;

  ProfileBottom({
    required this.initialGradientButtonText,
    required this.onInitialGradientButtonPressed,
    required this.onCallButtonPressed,
    required this.onChatButtonPressed,
    this.tokenEntity,
  });

  @override
  _ProfileBottomState createState() => _ProfileBottomState();
}

class _ProfileBottomState extends State<ProfileBottom> {
  late String _gradientButtonText;
  late String _gradientButtonIcon;
  late VoidCallback _gradientButtonAction;
  String _currentMode = 'wink';
  final Color _selectedColor = kPrimaryColor;

  @override
  void initState() {
    super.initState();
    _resetToInitialState();
  }

  void _resetToInitialState() {
    _gradientButtonText = widget.initialGradientButtonText;
    _gradientButtonIcon = ImageRes.iconLoveInactive;
    _gradientButtonAction = widget.onInitialGradientButtonPressed;
    _currentMode = 'wink';
  }

  void _setGradientButton(String mode, String text, String icon, VoidCallback action) {
    setState(() {
      if (_currentMode == mode) {
        _resetToInitialState();
      } else {
        _gradientButtonText = text;
        _gradientButtonIcon = icon;
        _gradientButtonAction = action;
        _currentMode = mode;
      }
    });
  }

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
              Positioned(
                left: 42.w,
                top: 14.h,
                child: GestureDetector(
                  onTap: () => _setGradientButton(
                      ConstantData.callButton,
                      ConstantData.callButton,
                      ImageRes.imagePathIconCallNoText,
                      widget.onCallButtonPressed
                  ),
                  child: Image.asset(
                    ImageRes.imagePathIconCall,
                    width: 24.w,
                    height: 43.5.h,
                    color: _currentMode == 'call' ? _selectedColor : null,
                  ),
                ),
              ),
              Positioned(
                left: 100.w,
                top: 14.h,
                child: GestureDetector(
                  onTap: () => _setGradientButton(
                      'chat',
                      ConstantData.chatButton,
                      ImageRes.iconChatInactive,
                      widget.onChatButtonPressed
                  ),
                  child: Image.asset(
                    ImageRes.imagePathIconChat,
                    width: 24.w,
                    height: 43.5.h,
                    color: _currentMode == 'chat' ? _selectedColor : null,
                  ),
                ),
              ),
              Positioned(
                left: 150.w,
                top: 12.h,
                child: GradientButton(
                  text: _gradientButtonText,
                  onPressed: _gradientButtonAction,
                  iconPath: _gradientButtonIcon,
                  width: 177.w,
                  textStyle: ConstantStyles.bottomBarTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}