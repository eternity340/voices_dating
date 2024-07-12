import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/background.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import 'change_username_controller.dart';


class ChangeUsername extends StatefulWidget {
  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final ChangeUsernameLogic logic = Get.put(ChangeUsernameLogic());

  @override
  Widget build(BuildContext context) {
    final tokenEntity = Get.arguments['token'] as TokenEntity;
    final userData = Get.arguments['userData'] as UserDataEntity;

    return Scaffold(
      body: Background(
        showBackgroundImage: false,
        showMiddleText: true,
        middleText: 'Username',
        showActionButton: false,
        child: Stack(
          children: [
            Positioned(
              top: 80,
              left: MediaQuery.of(context).size.width / 2 - 167.5, // 居中水平放置，减去一半的输入框宽度
              child: Container(
                width: 335.0,
                height: 56.0,
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F9),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: logic.controller,
                  style: const TextStyle(
                    fontFamily: 'Poppins', // 使用 Poppins 字体
                    fontSize: 18.0, // 设置字号为 18
                  ),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent, // 输入框背景透明
                    border: InputBorder.none, // 去掉默认的边框样式
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // 增加垂直间距
                  ),
                  onChanged: (text) {
                    setState(() {
                      logic.charCount = text.length;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              top: 141, // 80 + 56 + 5
              left: MediaQuery.of(context).size.width / 2 - 167.5, // 居中水平放置，减去一半的输入框宽度
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Enter up to 16 characters',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.0,
                      color: Colors.black,
                      letterSpacing: 0.02,
                    ),
                  ),
                  const SizedBox(width: 190),
                  Text(
                    '${logic.charCount}/16',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.0,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ],
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
                width: 88,
                height: 36,
                child: TextButton(
                  onPressed: () => logic.saveUsername(tokenEntity, userData), // 调用保存方法
                  child: const Text(
                    'Save',
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
