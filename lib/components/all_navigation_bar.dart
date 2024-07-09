import 'package:first_app/entity/user_data_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/constant_data.dart';
import '../entity/token_entity.dart';

class AllNavigationBar extends StatelessWidget {
  final TokenEntity tokenEntity; // 添加 tokenEntity 属性
  final UserDataEntity userData; // 添加 userData 属性

  AllNavigationBar({required this.tokenEntity, required this.userData}); // 构造函数接收 tokenEntity 和 userData

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 355,
              height: 72,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10), // 设置圆角半径
                    child: Image.asset(
                      ConstantData.imagePathNavigationBar,
                      width: 355,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25), // 设置与图片相同的圆角半径
                    child: Container(
                      width: 355,
                      height: 72,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  Positioned(
                    left: 40,
                    top: 26,
                    child: Row(
                      children: [
                        _buildNavItem(ConstantData.imagePathIconHomeActive, ConstantData.imagePathIconHomeInactive, '/home', userData),
                        SizedBox(width: 43),
                        _buildNavItem(ConstantData.imagePathIconBlogActive, ConstantData.imagePathIconBlogInactive, '/blog', userData),
                        SizedBox(width: 43),
                        _buildNavItem(ConstantData.imagePathIconVoiceActive, ConstantData.imagePathIconVoiceInactive, '/voice', userData),
                        SizedBox(width: 43),
                        _buildNavItem(ConstantData.imagePathIconMessageActive, ConstantData.imagePathIconMessageInactive, '/message', userData),
                        SizedBox(width: 43),
                        _buildNavItem(ConstantData.imagePathIconMeActive, ConstantData.imagePathIconMeInactive, '/me', userData),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(String activeIcon, String inactiveIcon, String route, UserDataEntity userData) {
    bool isActive = Get.currentRoute == route;
    return GestureDetector(
      onTap: () {
        Get.toNamed(route, arguments: {'token': tokenEntity, 'userData': userData}); // 传递 tokenEntity 和 userData
      },
      child: Image.asset(
        isActive ? activeIcon : inactiveIcon,
        width: 23,
        height: 24,
      ),
    );
  }
}
