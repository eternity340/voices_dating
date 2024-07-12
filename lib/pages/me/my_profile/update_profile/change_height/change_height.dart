import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/background.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import '../../../../pre_login/sign_up/components/height_picker.dart';
import 'change_height_controller.dart';


class ChangeHeight extends StatefulWidget {
  final TokenEntity tokenEntity = Get.arguments['token'] as TokenEntity;
  final UserDataEntity userData = Get.arguments['userData'] as UserDataEntity;

  @override
  _ChangeHeightState createState() => _ChangeHeightState();
}

class _ChangeHeightState extends State<ChangeHeight> {
  final ChangeHeightController _controller = ChangeHeightController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        showBackgroundImage: false,
        showActionButton: false,
        showMiddleText: true,
        middleText: 'Height',
        child: Stack(
          children: [
            Positioned(
              top: 100.0, // 调整顶部间距
              left: 0.0, // 调整左边距
              right: 0.0, // 调整右边距
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      "Change Height",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    HeightPicker(
                      initialHeight: _controller.selectedHeight,
                      onHeightChanged: (newHeight) {
                        setState(() {
                          _controller.selectedHeight = newHeight;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 4.0, // 留出顶部间距
              right: 16.0, // 添加右侧间距
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(-8, 0, 0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFD6FAAE), Color(0xFF20E2D7)],
                  ),
                  borderRadius: BorderRadius.circular(24.5),
                ),
                width: 88, // 调整按钮宽度适应文本
                height: 36,
                child: TextButton(
                  onPressed: () => _controller.updateHeight(), // 调用更新高度方法
                  child: const Text(
                    'save',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
