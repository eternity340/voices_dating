import 'package:first_app/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getx.GetMaterialApp(
      title: 'Email Verification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/sign_in', // 设置初始路由为登录页面
      getPages: AppRoutes.routes, // 使用单独文件中的路由配置
    );
  }
}
