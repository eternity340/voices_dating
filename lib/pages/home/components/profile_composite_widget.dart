import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart'; // Ensure this path is correct

class ProfileCompositeWidget extends StatefulWidget {
  final ListUserEntity? userEntity;
  final TokenEntity tokenEntity;

  ProfileCompositeWidget({Key? key, required this.userEntity, required this.tokenEntity}) : super(key: key);

  @override
  _ProfileCompositeWidgetState createState() => _ProfileCompositeWidgetState();
}

class _ProfileCompositeWidgetState extends State<ProfileCompositeWidget> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isPlaying = false;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    print(_isPlaying ? 'Playing' : 'Paused');
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    int photoCount = (widget.userEntity?.photos?.length ?? 0).clamp(0, 9);

    return Stack(
      children: [
        // Profile Card Widget
        Container(
          decoration: BoxDecoration(
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
                            decoration: BoxDecoration(
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

        // Photo Wall Widget
        Positioned(
          bottom: 16.h,
          left: 0,
          right: 0,
          child: Container(
            width: 337.w,
            height: 322.h,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: photoCount,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    String? photoUrl = widget.userEntity?.photos?[index].url;
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.r),
                        child: photoUrl != null
                            ? Image.network(
                          photoUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                            : Container(
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 10.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        photoCount,
                            (index) => _buildPageIndicator(index),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Play/Pause Button
        Positioned(
          left: 16.w,
          top: 116.h,
          child: GestureDetector(
            onTap: _togglePlayPause,
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

        // Like Button
        Positioned(
          left: 230.w,
          top: 127.h,
          child: GestureDetector(
            onTap: _toggleLike,
            child: Image.asset(
              _isLiked ? 'assets/images/icon_love_select.png' : 'assets/images/icon_love_unselect.png',
              width: 15.83.w,
              height: 13.73.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator(int index) {
    Color selectedColor = Color.fromRGBO(59, 59, 59, 1); // #3B3B3B
    Color unselectedColor = Color.fromRGBO(255, 255, 255, 0.56); // #FFFFFF with 56% opacity
    double indicatorWidth = 21.w;
    double indicatorHeight = 5.h;
    double indicatorSpacing = 8.w;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: indicatorSpacing),
      width: indicatorWidth,
      height: indicatorHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        color: _currentPage == index ? selectedColor : unselectedColor,
      ),
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
