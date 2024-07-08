import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../components/profile_photo_wall.dart';
import 'profile_detail_controller.dart';
import '../../../entity/list_user_entity.dart';
import '../components/profile_card.dart'; // Import the ProfileCard component

class ProfileDetailPage extends StatelessWidget {
  final ProfileDetailController controller;

  ProfileDetailPage({Key? key, required ListUserEntity userEntity})
      : controller = ProfileDetailController(userEntity: userEntity),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(
            showSettingButton: false,
            showBackButton: false,
            child: Center(),
          ),
          Positioned.fill(
            top: 0,
            bottom: 72,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/back.png', // 更改为PNG文件路径
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 8), // 图片和文字之间的间距
                              const Text(
                                'Back',
                                style: TextStyle(
                                  fontFamily: 'OpenSans', // 使用Open Sans字体
                                  fontSize: 14, // 设置字号为14sp
                                  color: Colors.black, // 根据需要设置文字颜色
                                  letterSpacing: 2, // 设置字距为2px
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // 处理设置按钮点击事件
                            // 这里可以实现跳转到设置页面或其他设置相关操作
                          },
                          child: Image.asset(
                            'assets/images/button_round_setting.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16), // Add some spacing between the row and the photo wall
                  Stack(
                    clipBehavior: Clip.none, // Ensure overlapping content is visible
                    children: [
                      Center(
                        child: ProfilePhotoWall(controller: controller), // Use the PhotoWall widget here
                      ),
                      Positioned(
                        top: 280, // Adjust the top position to place the ProfileCard over the PhotoWall
                        left: MediaQuery.of(context).size.width * 0.5 - 141.5, // Center the ProfileCard horizontally
                        child: Container(
                          width: 283,
                          height: 166,
                          child: ProfileCard(userEntity: controller.userEntity), // Use the ProfileCard component here
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 156), // Space between ProfileCard and Headline

                  Container(
                    width: 355,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Headline',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Open Sans',
                            color: Color(0xFF000000),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          controller.userEntity.headline ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Open Sans',
                            height: 1.5, // 24px line height
                            letterSpacing: -0.01,
                            color: Color(0xFF000000),
                          ),
                        ),
                        SizedBox(height: 50), // Space between headline and moments
                        const Text(
                          'Moments',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Open Sans',
                            color: Color(0xFF000000),
                          ),
                        ),
                        SizedBox(height: 16), // Space between moments and photo slider
                        Stack(
                          children: [
                            Container(
                              height: 105,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.asset(
                                        'assets/images/0${index + 1}.jpg',
                                        width: 105,
                                        height: 105,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 50), // Space between moments and About Me
                        const Text(
                          'About Me',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Open Sans',
                            color: Color(0xFF000000),
                          ),
                        ),
                        SizedBox(height: 16), // Space between About Me and user details
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/icon_height.png',
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 16),
                            Text(
                              (controller.userEntity.height != null ? '${controller.userEntity.height}cm' : ''),
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Open Sans',
                                height: 1.5, // 24px line height
                                letterSpacing: -0.01,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16), // Space between rows
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/icon_occupation.png',
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 16),
                            // Text(
                            //   controller.userEntity.occupation ?? '',
                            //   style: const TextStyle(
                            //     fontSize: 16,
                            //     fontFamily: 'Open Sans',
                            //     height: 1.5, // 24px line height
                            //     letterSpacing: -0.01,
                            //     color: Color(0xFF000000),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 16), // Space between rows
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/icon_language.png',
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 16),
                            Text(
                              controller.userEntity.language ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Open Sans',
                                height: 1.5, // 24px line height
                                letterSpacing: -0.01,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16), // Space between rows
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/icon_emotional_state.png',
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 16),
                            // Text(
                            //   controller.userEntity.emotionalState ?? '',
                            //   style: const TextStyle(
                            //     fontSize: 16,
                            //     fontFamily: 'Open Sans',
                            //     height: 1.5, // 24px line height
                            //     letterSpacing: -0.01,
                            //     color: Color(0xFF000000),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Add some padding at the bottom
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 72,
              width: 375,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x5CD4D7E0),
                    offset: Offset(0, -20),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 89.76, sigmaY: 89.76),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white.withOpacity(0.7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 52),
                        Image.asset(
                          'assets/images/icon_call.png',
                          width: 24,
                          height: 43.5,
                        ),
                        SizedBox(width: 52),
                        Image.asset(
                          'assets/images/icon_message.png',
                          width: 24,
                          height: 43.5,
                        ),
                        Spacer(),
                        GradientButton(
                          text: 'wink',
                          onPressed: () {},
                          width: 177,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            letterSpacing: 2.0,
                          ),
                        ),
                        SizedBox(width: 16), // Add some padding on the right
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
