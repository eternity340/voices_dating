import 'package:first_app/components/background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';

class ChangeHeadline extends StatefulWidget {
  @override
  _ChangeHeadlineState createState() => _ChangeHeadlineState();
}

class _ChangeHeadlineState extends State<ChangeHeadline> {
  final TextEditingController _controller = TextEditingController();
  int _charCount = 0;

  @override
  Widget build(BuildContext context) {
    final tokenEntity = Get.arguments['token'] as TokenEntity;
    final userData = Get.arguments['userData'] as UserDataEntity;

    return Scaffold(
      body: Background(
        showBackgroundImage: false,
        showMiddleText: true,
        middleText: 'Headline',
        showActionButton: true,
        child: Stack(
          children: [
            Positioned(
              top: 80,
              left: MediaQuery.of(context).size.width / 2 - 167.5, // 居中水平放置，减去一半的输入框宽度
              child: Container(
                width: 335.0,
                height: 200.0, // 增加容器高度以适应多行文本
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F9),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(
                    fontFamily: 'Poppins', // 使用 Poppins 字体
                    fontSize: 18.0, // 设置字号为 18
                  ),
                  maxLines: null, // 允许多行输入
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent, // 输入框背景透明
                    border: InputBorder.none, // 去掉默认的边框样式
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // 增加垂直间距
                  ),
                  onChanged: (text) {
                    setState(() {
                      _charCount = text.length;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              top: 286, // 80 + 200 + 6
              left: MediaQuery.of(context).size.width / 2 - 167.5, // 居中水平放置，减去一半的输入框宽度
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Enter up to 50 characters',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.0,
                      color: Colors.black,
                      letterSpacing: 0.02,
                    ),
                  ),
                  const SizedBox(width: 180), // 调整宽度以匹配更长的提示文本
                  Text(
                    '$_charCount/50',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.0,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
