import 'package:first_app/components/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../../components/path_box.dart';

class AboutMePage extends StatelessWidget {
  final tokenEntity = Get.arguments['token'] as TokenEntity;
  final userData = Get.arguments['userData'] as UserDataEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showMiddleText: true,
            middleText: ' About me',
            showBackgroundImage: false,
            showBackButton: true,
            child: Container(),
          ),
          Positioned(
            left: 142.w,
            top: 139.h,
            child: Container(
              width: 91.w,
              height: 91.h,
              decoration: BoxDecoration(
                color: Color(0xFFD8D8D8),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          PathBox(
            top: 300.h,
            text: 'Privacy agreement',
            onPressed: () {
              Get.toNamed('', arguments: {'token': tokenEntity, 'userData': userData});
            },
          ),
          Positioned(
            left: 167.5.w,
            top: 712.5.h,
            child: Text(
              'V1.0',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
