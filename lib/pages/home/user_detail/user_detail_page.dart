
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import 'user_detail_controller.dart';
import '../../../entity/list_user_entity.dart';

class UserDetailPage extends StatelessWidget {
  final UserDetailController controller;

  UserDetailPage({super.key, required ListUserEntity userEntity})
      : controller = UserDetailController(userEntity: userEntity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(
            showSettingButton: true,
            child: Center(),
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
