import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Background extends StatelessWidget {
  final Widget child;
  final bool showBackButton; // 控制是否显示返回按钮
  final bool showSettingButton; // 控制是否显示设置按钮
  final bool showBackgroundImage; // 控制是否显示背景图片
  final String? middleText; // 中间文字
  final bool showMiddleText; // 控制是否显示中间文字
  final bool showActionButton; // 控制是否显示按钮

  const Background({
    Key? key,
    required this.child,
    this.showBackButton = true, // 默认显示返回按钮
    this.showSettingButton = false, // 默认不显示设置按钮
    this.showBackgroundImage = true, // 默认显示背景图片
    this.middleText,
    this.showMiddleText = false, // 默认不显示中间文字
    this.showActionButton = false, // 默认不显示按钮
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 防止键盘弹出时调整布局
      body: Stack(
        children: [
          if (showBackgroundImage)
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/icons/bg.svg',
                fit: BoxFit.fill, // 使用fill以填充整个屏幕
              ),
            ),
          // 页面内容
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8.0, // 留出顶部间距
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Stack(
                children: [
                  child,
                  if (showBackButton)
                    Positioned(
                      top: 8.0, // 留出顶部间距
                      left: 16.0, // 添加左侧间距
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // 返回上一个页面
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/back.png', // 更改为PNG文件路径
                              width: 24, // 设置返回按钮的宽度
                              height: 24, // 设置返回按钮的高度
                            ),
                            SizedBox(width: 8), // 图片和文字之间的间距
                            const Text(
                              'Back',
                              style: TextStyle(
                                fontFamily: 'OpenSans', // 使用Open Sans字体
                                fontSize: 14, // 设置字号为14sp
                                color: Colors.black, // 根据需要设置文字颜色
                                letterSpacing: 2, // 设置字距为2px
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (showMiddleText && middleText != null)
                    Positioned(
                      top: 8.0, // 留出顶部间距
                      left: MediaQuery.of(context).size.width / 2 - 50,
                      child: Text(
                        middleText!,
                        style: const TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 22 / 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  if (showActionButton)
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
                          onPressed: () {
                            Navigator.of(context).pop();
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
                    ),
                  if (showSettingButton)
                    Positioned(
                      top: 8.0, // 留出顶部间距
                      right: 16.0, // 添加右侧间距
                      child: GestureDetector(
                        onTap: () {
                          // 处理设置按钮点击事件
                          // 这里可以实现跳转到设置页面或其他设置相关操作
                        },
                        child: Image.asset(
                          'assets/images/button_round_setting.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
