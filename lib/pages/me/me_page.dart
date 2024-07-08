import 'package:first_app/entity/token_entity.dart';
import 'package:first_app/entity/user_data_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/all_navigation_bar.dart';
import '../../components/background.dart';
import 'me_controller.dart';

class MePage extends StatelessWidget {
  final MeController controller = Get.put(MeController());


  @override
  Widget build(BuildContext context) {
    final tokenEntity = Get.arguments['token'] as TokenEntity;
    final userDataEntity = Get.arguments['userData'] as UserDataEntity;
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: false,
            showSettingButton: false,
            child: Container(), // 保持child参数的存在
          ),
          Positioned(
            top: 60.0,
            right: 24.0,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  color: Colors.red.withOpacity(0.5), // 添加一个半透明的红色背景以便调试
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/icon_me_left.png',
                      width: 40,
                      height: 40,
                    ),
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                  ),
                ),
                SizedBox(width: 24), // 间隔24px
                Container(
                  width: 40,
                  height: 40,
                  color: Colors.blue.withOpacity(0.5), // 添加一个半透明的蓝色背景以便调试
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/icon_me_right.png',
                      width: 40,
                      height: 40,
                    ),
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 130.0,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 外部椭圆形的线圈
                  CustomPaint(
                    size: Size(95, 95),
                    painter: OuterOvalPainter(),
                  ),
                  // 内部的椭圆形图片
                  ClipOval(
                    child: Image.asset(
                      'assets/images/08.jpg',
                      width: 95,
                      height: 95,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD7FAAD),
                      ),
                      child: IconButton(
                        icon: Image.asset(
                          'assets/images/icon_add_photo.png',
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          // Add your onPressed logic here
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() => Positioned(
            top: 240.0, // 调整这个值以控制文字相对于图片的垂直位置
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    controller.username.value,
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2), // 文字间距
                  Row(
                    mainAxisSize: MainAxisSize.min, // 使 Row 的宽度适应其子组件的宽度
                    children: [
                      Text(
                        controller.country.value,
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 14,
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        '|',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Open Sans',
                          color: Color(0xFF8E8E93),
                        ),
                      ), // 数字和文字间距
                      SizedBox(width: 2),
                      Text(
                        controller.age.value.toString(),
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 14,
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
          Positioned(
            top: 330,
            left: MediaQuery.of(context).size.width / 2 - 167.5, // 居中放置
            child: Stack(
              children: [
                // 这里是你需要添加的蒙版
                Container(
                  width: 335,
                  height: 116,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(216, 216, 216, 0.01), // 填充颜色
                    borderRadius: BorderRadius.circular(10), // 圆角
                    border: Border.all(
                      color: Colors.black,
                      width: 2, // 外描边
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/buy_cactus.png',
                  width: 335,
                  height: 117,
                  fit: BoxFit.contain, // 根据需要调整 fit 属性
                ),
              ],
            ),
          ),
          Positioned(
            top: 500, // 330 (top of image) + 51.5 (additional space)
            left: MediaQuery.of(context).size.width / 2 - 167.5, // Center horizontally
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/icon_person.png',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 16), // Adjust spacing as needed
                    Text(
                      'My Profile',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Space between "My Profile" and the line

                // Line 1
                Container(
                  width: 303,
                  height: 1,
                  color: Color(0xFFEBEBEB),
                ),
                SizedBox(height: 30), // Space between line and "Verify"

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/icon_verify.png',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 16), // Adjust spacing as needed
                    Text(
                      'Verify',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Space between "Verify" and the line

                // Line 2
                Container(
                  width: 303,
                  height: 1,
                  color: Color(0xFFEBEBEB),
                ),
                SizedBox(height: 30), // Space between line and "icon_host"

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/icon_host.png',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 16), // Adjust spacing as needed
                    Text(
                      'I am Host',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: 303,
                  height: 1,
                  color: Color(0xFFEBEBEB),
                ),
              ],
            ),
          ),
          AllNavigationBar(tokenEntity: tokenEntity),
        ],
      ),
    );
  }
}

// 自定义外部椭圆形的线圈Painter
class OuterOvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const Gradient gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: 2 * 3.14,
      colors: [
        Color(0xFFF3ADF8),
        Color(0xFFFAC492),
        Color(0xFFF9C39D),
        Color(0xFF8BEAFF),
        Color(0xFF8AECFF),
        Color(0xFFBFCCFF),
      ],
      stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
    );

    final Paint paint = Paint()..shader = gradient.createShader(rect);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4.0;

    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
