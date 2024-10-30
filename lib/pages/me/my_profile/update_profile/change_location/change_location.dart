import 'package:voices_dating/components/background.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../constants/Constant_styles.dart';
import '../../../../../constants/constant_data.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import '../../../../../image_res/image_res.dart';
import '../../../../../components/custom_content_dialog.dart';
import '../../my_profile_page.dart';

class ChangeLocation extends StatelessWidget {
  final TokenEntity tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
  final UserDataEntity userData = Get.arguments['userDataEntity'] as UserDataEntity;

  String getFormattedLocation() {
    List<String> locationParts = [];
    if (userData.location?.city?.isNotEmpty == true) {
      locationParts.add(userData.location!.city!);
    }
    if (userData.location?.state?.isNotEmpty == true) {
      locationParts.add(userData.location!.state!);
    }
    if (userData.location?.country?.isNotEmpty == true) {
      locationParts.add(userData.location!.country!);
    }
    return locationParts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    String formattedLocation = getFormattedLocation();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        navigateToMyProfile();
      },
      child: Scaffold(
        body: Background(
          showMiddleText: true,
          middleText: ConstantData.locationHeaderTitle,
          showBackgroundImage: false,
          onBackPressed: navigateToMyProfile,
          child: Stack(
            children: [
              Positioned(
                top: 80.h,
                left: 10.w,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.meLocationDetail, arguments: {
                      'userDataEntity': userData,
                      'tokenEntity': tokenEntity,
                    });
                  },
                  child: Container(
                    width: 335.w,
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F8F9),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text(
                              formattedLocation,
                              style: ConstantStyles.changeLocationTextStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Image.asset(
                            ImageRes.iconLocationImagePath,
                            width: 24.w,
                            height: 24.h,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomContentDialog(
                                  title: 'Location',
                                  content: formattedLocation,
                                  buttonText: 'OK',
                                  onButtonPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToMyProfile() {
    Get.offAll(
          () => MyProfilePage(),
      arguments: {
        'tokenEntity': tokenEntity,
        'userDataEntity': userData,
      },
      transition: Transition.cupertinoDialog,
      duration: Duration(milliseconds: 500),
    );
  }
}
