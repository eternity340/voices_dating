import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constant_data.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';

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
                    // 返回上一个页面
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
                  if (index == 0) {
                    selectedOption = "Profile";
                  } else {
                    selectedOption = "Moments";
                  }
                });
              },
              children: [
                _buildProfileContent(context, tokenEntity, userData),
                _buildMomentsContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String selectedOption = "Profile"; // 默认选中 "Profile"

  void _selectOption(String option) {
    setState(() {
      selectedOption = option; // 更新选中的选项
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
                ConstantData.imagePathDecorate,
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

  Widget _buildProfileContent(BuildContext context, TokenEntity tokenEntity, UserDataEntity userData) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(
              context,
              title: 'Username',
              value: userData.username,
              onTap: () {
                Get.toNamed('/me/my_profile/change_username', arguments: {'token': tokenEntity, 'userData': userData});
              },
            ),
            _buildInfoSection(
              context,
              title: 'Age',
              value: userData.age.toString(),
              onTap: () {
                Get.toNamed('/me/my_profile/change_age', arguments: {'token': tokenEntity, 'userData': userData});
              },
            ),
            _buildInfoSection(
              context,
              title: 'Height',
              value: userData.height != null ? '${userData.height} cm' : '',
              onTap: () {
                Get.toNamed('/me/my_profile/change_height', arguments: {'token': tokenEntity, 'userData': userData});
              },
            ),
            _buildInfoSection(
              context,
              title: 'Headline',
              value: userData.headline.toString(),
              onTap: () {
                Get.toNamed('/me/my_profile/change_headline', arguments: {'token': tokenEntity, 'userData': userData});
              },
            ),
            _buildInfoSection(
              context,
              title: 'Location',
              value: userData.location != null &&
                  userData.location!.city != null &&
                  userData.location!.country != null
                  ? '${userData.location!.city}, ${userData.location!.country}'
                  : '',
              onTap: () {
                // 处理跳转到用户图片按钮相关路由
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMomentsContent() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text(
            'Moments Section',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          // 添加 Moments 相关内容
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, {
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: Color(0xFF8E8E93),
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(left: 300.0),
            child: Image.asset(
              'assets/images/Path.png',
              width: 18,
              height: 18,
            ),
          ),
        ),
        Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          width: 330,
          height: 1,
          color: Color(0xFFEBEBEB),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
