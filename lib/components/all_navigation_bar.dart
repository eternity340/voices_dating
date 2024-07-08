import 'package:first_app/entity/user_data_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/constant_data.dart';
import '../entity/token_entity.dart';

class AllNavigationBar extends StatelessWidget {
  final TokenEntity tokenEntity; // 添加 tokenEntity 属性

  AllNavigationBar({required this.tokenEntity}); // 构造函数接收 tokenEntity

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
                        _buildNavItem(ConstantData.imagePathIconHomeActive, ConstantData.imagePathIconHomeInactive, '/home'),
                        SizedBox(width: 43),
                        _buildNavItem(ConstantData.imagePathIconBlogActive, ConstantData.imagePathIconBlogInactive, '/blog'),
                        SizedBox(width: 43),
                        _buildNavItem(ConstantData.imagePathIconVoiceActive, ConstantData.imagePathIconVoiceInactive, '/voice'),
                        SizedBox(width: 43),
                        _buildNavItem(ConstantData.imagePathIconMessageActive, ConstantData.imagePathIconMessageInactive, '/message'),
                        SizedBox(width: 43),
                        _buildNavItem(ConstantData.imagePathIconMeActive, ConstantData.imagePathIconMeInactive, '/me'),
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

  Widget _buildNavItem(String activeIcon, String inactiveIcon, String route) {
    bool isActive = Get.currentRoute == route;
    return GestureDetector(
      onTap: () {
        Get.toNamed(route, arguments: {'token': tokenEntity}); // 传递 tokenEntity
      },
      child: Image.asset(
        isActive ? activeIcon : inactiveIcon,
        width: 23,
        height: 24,
      ),
    );
  }
}
