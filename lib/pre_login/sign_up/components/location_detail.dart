import 'package:flutter/material.dart';
import '../../../entity/User.dart';
import '../../../components/background.dart';
import 'location_box.dart'; // 导入新的组件

class LocationDetailPage extends StatelessWidget {
  final User user;

  const LocationDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      showBackButton: false, // 设置不显示返回按钮
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0), // 添加顶部间距
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Do nothing here to disable the back button functionality
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/back.png',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 8),
                      const Text(
                        'Back',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 14,
                          color: Colors.black,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Location',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 22 / 18,
                    color: Colors.black,
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300), // 设置动画持续时间
                  curve: Curves.easeOut, // 设置动画曲线
                  transform: Matrix4.translationValues(-8, 0, 0), // 向左移动的动画效果
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft, // 调整开始位置
                      end: Alignment.centerRight, // 调整结束位置
                      colors: [Color(0xFFD6FAAE), Color(0xFF20E2D7)], // 调整颜色顺序
                    ),
                    borderRadius: BorderRadius.circular(24.5),
                  ),
                  width: 88,
                  height: 36,
                  child: TextButton(
                    onPressed: () {
                      // Logic for saving selected data
                    },
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
              ],
            ),
          ),
          SizedBox(height: 100), // 添加间距

          // 添加三个 LocationBox
          _buildLocationBox('Location Box 1', 'assets/images/Path.png'),
          SizedBox(height: 20), // 添加间距
          _buildLocationBox('Location Box 2', 'assets/images/Path.png'),
          SizedBox(height: 20), // 添加间距
          _buildLocationBox('Location Box 3', 'assets/images/Path.png'),

          // Other page content
        ],
      ),
    );
  }

  Widget _buildLocationBox(String text, String iconPath) {
    return GestureDetector(
      onTap: () {
        // 处理点击事件
      },
      child: Container(
        width: 335,
        height: 69,
        decoration: BoxDecoration(
          color: Color(0xFFF8F8F9), // 背景颜色
          borderRadius: BorderRadius.circular(10), // 圆角
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // 内边距
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Image.asset(
                iconPath,
                width: 10,
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
