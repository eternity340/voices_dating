import 'package:flutter/material.dart';

import '../../../constants/constant_data.dart';

class HomeNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16, // 根据需要调整位置
      left: 0,
      right: 0,
      child: Container(
        width: 300, // 调整容器的宽度
        height: 72,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Color(0xD4D7E0).withOpacity(0.3663),
              blurRadius: 89.76,
              offset: Offset(0, 20),
              spreadRadius: 30,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Image.asset(
            ConstantData.imagePathNavigationBar,
            width: 300, // 调整图片的宽度
            height: 72,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
