import 'package:flutter/services.dart';
import 'package:voices_dating/components/background.dart';
import 'package:voices_dating/pages/me/me_page.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/constant_styles.dart';
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
    final tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
    final userData = Get.arguments['userDataEntity'] as UserDataEntity;

    void navigateToMePage() {
      Get.to(
            () => MePage(),
        arguments: {
          'tokenEntity': tokenEntity,
          'userDataEntity': userData,
          'isMeActive': true,
        },
        transition: Transition.cupertinoDialog,
        duration: Duration(milliseconds: 500),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        navigateToMePage();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Background(
                showBackButton: true,
                showMiddleText: true,
                middleText: ConstantData.myProfileTitle,
                showBackgroundImage: false,
                onBackPressed: navigateToMePage,
                child: Stack()),
            Positioned(
              top: 100.h,
              left: 10.w,
              right: 0,
              child: _buildOptionsRow(),
            ),
            Positioned(
              top: 170.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    selectedOption = index == 0
                        ? ConstantData.profileOption
                        : ConstantData.momentsOption;
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
      ),
    );
  }

  String selectedOption = ConstantData.profileOption;

  void _selectOption(String option) {
    setState(() {
      selectedOption = option;
      _pageController.animateToPage(
        option == ConstantData.profileOption ? 0 : 1,
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
          height: 40.h,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOption(ConstantData.profileOption),
              SizedBox(width: 100.w),
              _buildOption(ConstantData.momentsOption),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          width: double.infinity,
          height: 1.h,
          color: Color(0xFFEBEBEB),
        ),
      ],
    );
  }

  //按钮样式
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
                width: 17.w,
                height: 17.h,
              ),
            ),
          Text(
            option,
            style: isSelected
                ? ConstantStyles.optionSelectedTextStyle
                : ConstantStyles.myProfileOptionTextStyle,
          ),
        ],
      ),
    );
  }
}
