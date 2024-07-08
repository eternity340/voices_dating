import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../profile_detail/profile_detail_controller.dart';


class ProfilePhotoWall extends StatefulWidget {
  final ProfileDetailController controller;

  ProfilePhotoWall({required this.controller});

  @override
  _PhotoWallState createState() => _PhotoWallState();
}

class _PhotoWallState extends State<ProfilePhotoWall> {
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
    return Container(
      width: 337,
      height: 322,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.controller.userEntity.photos?.length ?? 0,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              String? photoUrl = widget.controller.userEntity.photos?[index].url;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: photoUrl != null
                      ? Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    color: Colors.grey,
                  ), // Placeholder for missing photo
                ),
              );
            },
          ),
          Positioned(
            top: 10, // Top position aligned with the top of the image
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.controller.userEntity.photos?.length ?? 0,
                    (index) => _buildPageIndicator(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    Color selectedColor = Color.fromRGBO(59, 59, 59, 1); // #3B3B3B
    Color unselectedColor = Color.fromRGBO(255, 255, 255, 0.56); // #FFFFFF with 56% opacity
    double indicatorWidth = 21.0;
    double indicatorHeight = 5.0;
    double indicatorSpacing = 8.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: indicatorSpacing),
      width: indicatorWidth,
      height: indicatorHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: _currentPage == index ? selectedColor : unselectedColor,
      ),
    );
  }
}
