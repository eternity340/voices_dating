import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constant_data.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../image_res/image_res.dart';
import 'components/profile_content.dart';
import 'components/moments_content.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final tokenEntity = Get.arguments['token'] as TokenEntity;
    final userData = Get.arguments['userData'] as UserDataEntity;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 60.0,
            left: 16.0,
            right: 16.0,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/me', arguments: {'token': tokenEntity, 'userData': userData});
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/back.png',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 8),
                      const Text(
                        'Back',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 14,
                          color: Colors.black,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                const Text(
                  'My Profile',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 22 / 18,
                    letterSpacing: -0.011249999515712261,
                    color: Colors.black,
                  ),
                ),
                Spacer(flex: 2),
              ],
            ),
          ),
          Positioned(
            top: 120.0,
            left: 0,
            right: 0,
            child: _buildOptionsRow(),
          ),
          Positioned(
            top: 190.0,
            left: 0,
            right: 0,
            bottom: 0,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  selectedOption = index == 0 ? "Profile" : "Moments";
                });
              },
              children: [
                ProfileContent(tokenEntity: tokenEntity, userData: userData),
                MomentsContent(tokenEntity: tokenEntity, userData: userData),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String selectedOption = "Profile";

  void _selectOption(String option) {
    setState(() {
      selectedOption = option;
      _pageController.animateToPage(
        option == "Profile" ? 0 : 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _buildOptionsRow() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 40,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOption("Profile"),
              SizedBox(width: 88),
              _buildOption("Moments"),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 1,
          color: Color(0xFFEBEBEB),
        ),
      ],
    );
  }

  Widget _buildOption(String option) {
    bool isSelected = selectedOption == option;
    return GestureDetector(
      onTap: () {
        _selectOption(option);
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          if (isSelected)
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                ImageRes.imagePathDecorate,
                width: 17,
                height: 17,
              ),
            ),
          Text(
            option,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: isSelected ? Color(0xFF000000) : Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }
}
