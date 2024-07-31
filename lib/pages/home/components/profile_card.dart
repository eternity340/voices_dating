import 'package:first_app/entity/token_entity.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../entity/list_user_entity.dart';

class ProfileCard extends StatefulWidget {
  final ListUserEntity? userEntity;
  final TokenEntity tokenEntity;

  const ProfileCard({Key? key, required this.userEntity, required this.tokenEntity}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _isPlaying = false;
  bool _isLiked = false; // 新增变量

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    print(_isPlaying ? 'Playing' : 'Paused');
  }

  void _toggleLike() { // 新增方法
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.0642),
                offset: Offset(0, 7),
                blurRadius: 14,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 27.2, sigmaY: 27.2),
              child: Container(
                width: 283.w,
                height: 166.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.userEntity?.username ?? '',
                            style: _textStyle(20, Colors.black),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            width: 9.w,
                            height: 9.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFABFFCF),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 88.w,
                        height: 19.h,
                        decoration: BoxDecoration(
                          color: Color(0xFFABFFCF),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Center(
                          child: Text(
                            'Photos verified',
                            style: _textStyle(10, Color(0xFF262626), letterSpacing: 0.02),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Text(
                            widget.userEntity?.location?.country ?? '',
                            style: _textStyle(12, Color(0xFF8E8E93)),
                          ),
                          SizedBox(width: 4.w),
                          const Text(
                            '|',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              color: Color(0xFF8E8E93),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${widget.userEntity?.age ?? 0} years old',
                            style: _textStyle(12, Color(0xFF8E8E93)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 16.w,
          top: 116.h,
          child: GestureDetector(
            onTap: _togglePlayPause,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: Color(0xFF2FE4D4),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 20.w,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 230.w,
          top: 127.h,
          child: GestureDetector(
            onTap: _toggleLike,
            child: Material(
              color: Colors.transparent,
              child: Image.asset(
                _isLiked ? 'assets/images/icon_love_select.png' : 'assets/images/icon_love_unselect.png',
                width: 15.83.w,
                height: 13.73.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _textStyle(double fontSize, Color color, {String fontFamily = 'Open Sans', double letterSpacing = 0.0}) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontFamily: fontFamily,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}
