import 'package:first_app/components/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../constants/Constant_styles.dart';
import '../../../../../constants/constant_data.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import '../../../../../image_res/image_res.dart';

class ChangeLocation extends StatefulWidget {
  final TokenEntity tokenEntity = Get.arguments['token'] as TokenEntity;
  final UserDataEntity userData = Get.arguments['userData'] as UserDataEntity;

  @override
  _ChangeLocationState createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        showMiddleText: true,
        middleText: ConstantData.locationHeaderTitle,
        showActionButton: true,
        showBackgroundImage: false,
        child: Stack(
          children: [
            Positioned(
              top: 80.h,
              left: (MediaQuery.of(context).size.width / 2) - 167.5.w, // Center horizontally and subtract half of the input box width
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
                          '${widget.userData.location?.city}, ${widget.userData.location?.state}, ${widget.userData.location?.country}',
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
                        // Your location button logic
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
