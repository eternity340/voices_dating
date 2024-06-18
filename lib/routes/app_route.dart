import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../page/get_email_code_page.dart';
import '../provider/get_email_code_provider.dart';
import '../page/verify_email_page.dart';
import '../verify_success.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/get_mail_code',
      page: () => GetEmailCodeProvider(
        child: GetMailCodePage(),
      ),
    ),
    GetPage(
      name: '/verify_email',
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return VerifyEmailPage(
          email: args['email'],
          verificationKey: args['verificationKey'],
        );
      },
    ),
    GetPage(
      name: '/verify_success',
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return VerifySuccess(
          message: args['message'] ?? '',
        );
      },
    ),
  ];
}
