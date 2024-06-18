import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'page/get_email_code_page.dart'; // 导入邮箱输入页面
import 'provider/get_email_code_provider.dart';
import 'model/get_email_code_model.dart';
import 'verify_email.dart'; // 导入验证码输入页面
import 'verify_success.dart'; // 导入成功页面


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Email Verification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/get_mail_code', // 设置初始路由
      getPages: [
        GetPage(
          name: '/get_mail_code',
          page: () => ChangeNotifierProvider(
            create: (_) => GetEmailCodeModel(),
            child: GetMailCodePage(),
          ),
        ),
        GetPage(
          name: '/verify_email',
          page: () {
            final args = Get.arguments as Map<String, dynamic>;
            return VerifyEmailPage(
              email: args['email'] ?? '',
              verificationKey: args['key'] ?? '',
            );
          },
        ),
        GetPage(
          name: '/verify_success',
          page: () {
            final args = Get.arguments as Map<String, dynamic>;
            return VerifySuccessPage(
              message: args['message'] ?? '',
            );
          },
        ),
      ],
    );
  }
}
