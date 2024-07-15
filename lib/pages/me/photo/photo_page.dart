import 'package:first_app/components/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';

class PhotoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokenEntity = Get.arguments['token'] as TokenEntity;
    final userData = Get.arguments['userData'] as UserDataEntity;

    return Scaffold(
      body: Background(
        showBackgroundImage: false,
        showMiddleText: true,
        middleText: '    Photo',
        child: Stack(
          children: [
            // 主照片容器
            Positioned(
              top: 95,
              left: 38,
              child: Container(
                width: 137.09,
                height: 174,
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      // Handle button tap
                    },
                    child: Container(
                      width: 38.4,
                      height: 38.4,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/icon_add_photo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 95,
              left: 38 + 137.09 + 24,
              child: Container(
                width: 137.09,
                height: 174,
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: userData.avatar != null && userData.avatar!.isNotEmpty
                    ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        userData.avatar!,
                        fit: BoxFit.cover,
                        width: 137.09,
                        height: 174,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 137.09,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Color(0xFFABFFCF),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 137.09,
                        height: 34,
                        child: Center(
                          child: Text(
                            'main photo',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 24 / 14,
                              letterSpacing: -0.00875,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    : Container(),
              ),
            ),
            // 照片蒙版部分
            if (userData.photos != null)
              for (int i = 1; i < userData.photos!.length; i++)
                Positioned(
                  top: 95 + 174 + 24 + (i > 2 ? (174 + 24) * ((i - 3) ~/ 2 + 1) : 0),
                  left: 38 + ((i - 1) % 2) * (137.09 + 24),
                  child: Container(
                    width: 137.09,
                    height: 174,
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F8F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: userData.photos![i].url != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        userData.photos![i].url!,
                        fit: BoxFit.cover,
                        width: 137.09,
                        height: 174,
                      ),
                    )
                        : Container(),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
