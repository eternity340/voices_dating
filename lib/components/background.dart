import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class Background extends StatelessWidget {
  final Widget child;
  final bool showBackButton; // 控制是否显示返回按钮
  final bool showSettingButton; // 控制是否显示设置按钮

  const Background({
    Key? key,
    required this.child,
    this.showBackButton = true, // 默认显示返回按钮
    this.showSettingButton = false, // 默认不显示设置按钮
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 防止键盘弹出时调整布局
      body: Stack(
        children: [
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
              child: SingleChildScrollView(
                child: child,
              ),
            ),
          ),
          if (showBackButton)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16.0, // 紧贴状态栏，并留出一些间距
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
          if (showSettingButton)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16.0, // 紧贴状态栏，并留出一些间距
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
    );
  }
}
