import 'package:first_app/entity/user_data_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfilePhotoWall extends StatefulWidget {
  final UserDataEntity userDataEntity;

  UserProfilePhotoWall({required this.userDataEntity});

  @override
  _PhotoWallState createState() => _PhotoWallState();
}

class _PhotoWallState extends State<UserProfilePhotoWall> {
  late PageController _pageController;
  int _currentPage = 0;

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

  @override
  Widget build(BuildContext context) {
    int photoCount = (widget.userDataEntity.photos?.length ?? 0).clamp(0, 9);

    return Container(
      width: 400.w,
      height: 500.h,
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
              String? photoUrl = widget.userDataEntity.photos?[index].url;
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 337.w,
                  height: 322.h,
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
    );
  }

  Widget _buildPageIndicator(int index) {
    Color selectedColor = Color.fromRGBO(59, 59, 59, 1);
    Color unselectedColor = Color.fromRGBO(255, 255, 255, 0.56);
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
}
