import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart';
import 'audio_player_widget.dart';

class ProfileCard extends StatefulWidget {
  final ListUserEntity? userEntity;
  final TokenEntity tokenEntity;

  ProfileCard({Key? key, required this.userEntity, required this.tokenEntity}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  late bool _isLiked;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    // Initialize _isLiked based on the liked field from userEntity
    _isLiked = widget.userEntity?.liked == 1;
  }

  void _toggleLike() async {
    final url = _isLiked
        ? 'https://api.masonvips.com/v1/unlike_user'
        : 'https://api.masonvips.com/v1/like_user';

    if (widget.userEntity?.userId == null || widget.tokenEntity.accessToken == null) {
      return;
    }

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'token': '${widget.tokenEntity.accessToken}',
          },
        ),
        queryParameters: {
          'userId': widget.userEntity!.userId,
        },
      );

      if (response.data['code'] == 200) {
        // Successfully toggled like status
        setState(() {
          _isLiked = !_isLiked;
        });
      } else {
        // Handle error
        print('Failed to toggle like status: ${response.data}');
      }
    } catch (e) {
      // Handle exception
      print('Exception occurred: $e');
    }
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
          child: AudioPlayerWidget(audioPath: 'audio/AI_Sunday.mp3'),
        ),
        Positioned(
          left: 230.w,
          top: 125.h,
          child: GestureDetector(
            onTap: _toggleLike,
            child: Material(
              color: Colors.transparent,
              child: Image.asset(
                _isLiked ? 'assets/images/icon_love_select.png' : 'assets/images/icon_love_unselect.png',
                width: 20.83.w,
                height: 20.73.h,
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
