import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../entity/list_user_entity.dart';
import '../../../components/image_viewer_page.dart';

class ProfilePhotoWall extends StatefulWidget {
  final ListUserEntity userEntity;

  ProfilePhotoWall({required this.userEntity});

  @override
  _PhotoWallState createState() => _PhotoWallState();
}

class _PhotoWallState extends State<ProfilePhotoWall> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1000); // 从一个大的初始页开始
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int photoCount = (widget.userEntity.photos?.length ?? 0).clamp(0, 9);
    List<String> photoUrls = widget.userEntity.photos
        ?.map((photo) => photo.url ?? '')
        .where((url) => url.isNotEmpty)
        .toList() ?? [];

    return Container(
      width: 400.w,
      height: 500.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index % photoCount;
              });
            },
            itemBuilder: (context, index) {
              final actualIndex = index % photoCount;
              String? photoUrl = widget.userEntity.photos?[actualIndex].url;
              return GestureDetector(
                onTap: () {
                  Get.to(() => ImageViewerPage(
                    imageUrls: photoUrls,
                    initialIndex: actualIndex,
                  ));
                },
                child: Align(
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
        color: _currentPage == index
            ? selectedColor
            : unselectedColor,
      ),
    );
  }
}
