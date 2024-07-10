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
    final userData = Get.arguments['userData'] as UserDataEntity;
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: false,
            showSettingButton: false,
            child: Container(), // 保持child参数的存在
          ),
          _buildTopIcons(),
          _buildProfileSection(userData),
          _buildMiddleImageSection(context),
          _buildOptionsSection(context, tokenEntity, userData),
          AllNavigationBar(tokenEntity: tokenEntity, userData: userData),
        ],
      ),
    );
  }

  Positioned _buildTopIcons() {
    return Positioned(
      top: 60.0,
      right: 24.0,
      child: Row(
        children: [
          _buildIconButton('assets/images/icon_me_left.png', () {}),
          SizedBox(width: 24), // 间隔24px
          _buildIconButton('assets/images/icon_me_right.png', () {}),
        ],
      ),
    );
  }

  Widget _buildIconButton(String assetPath, VoidCallback onPressed) {
    return Container(
      width: 40,
      height: 40,
      child: IconButton(
        icon: Image.asset(assetPath, width: 40, height: 40),
        onPressed: onPressed,
      ),
    );
  }

  Positioned _buildProfileSection(UserDataEntity userData) {
    return Positioned(
      top: 130.0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(size: Size(95, 95), painter: OuterOvalPainter()),
                ClipOval(
                  child: Image.network(
                    userData.avatar ?? 'assets/images/placeholder1.png',
                    width: 95,
                    height: 95,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/placeholder1.png',
                        width: 95,
                        height: 95,
                        fit: BoxFit.cover,
                      );
                    },
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
                      icon: Image.asset('assets/images/icon_add_photo.png', width: 24, height: 24),
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // Avatar 下方 20px 间距
          Text(
            userData.username,
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10), // Username 下方 10px 间距
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (userData.location != null && userData.location!.country != null)
                Text(
                  userData.location!.country!,
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Color(0xFF8E8E93),
                  ),
                ),
              if (userData.location != null && userData.location!.country != null)
                Text(
                  ' | ',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Color(0xFF8E8E93),
                  ),
                ),
              Text(
                '${userData.age}',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Color(0xFF8E8E93),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Positioned _buildMiddleImageSection(BuildContext context) {
    return Positioned(
      top: 330,
      left: MediaQuery.of(context).size.width / 2 - 167.5, // 居中放置
      child: Stack(
        children: [
          Container(
            width: 335,
            height: 116,
            decoration: BoxDecoration(
              color: Color.fromRGBO(216, 216, 216, 0.01),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
          ),
          Image.asset(
            'assets/images/buy_cactus.png',
            width: 335,
            height: 117,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Positioned _buildOptionsSection(BuildContext context, TokenEntity tokenEntity, UserDataEntity userData) {
    return Positioned(
      top: 500,
      left: MediaQuery.of(context).size.width / 2 - 167.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOptionRow(
            iconPath: 'assets/images/icon_person.png',
            text: 'My Profile',
            onTap: () {
              Get.toNamed('/me/my_profile', arguments: {'token': tokenEntity, 'userData': userData});
            },
          ),
          _buildSeparator(),
          _buildOptionRow(iconPath: 'assets/images/icon_verify.png', text: 'Verify', onTap: () {}),
          _buildSeparator(),
          _buildOptionRow(iconPath: 'assets/images/icon_host.png', text: 'I am Host', onTap: () {}),
          _buildSeparator(),
        ],
      ),
    );
  }

  Widget _buildOptionRow({required String iconPath, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(iconPath, width: 24, height: 24),
          SizedBox(width: 16),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          width: 303,
          height: 1,
          color: Color(0xFFEBEBEB),
        ),
        SizedBox(height: 30),
      ],
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
