import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;

import '../email/page/get_email_code_page.dart';
import '../email/page/verify_email_page.dart';
import '../email/page/verify_success_page.dart';
import '../pre_login/sign_up/sign_up_page.dart';
import '../pre_login/welcome/welcome_page.dart';
import '../pre_login/welcome/welcome_provider.dart';
import '../email/provider/get_email_code_provider.dart';

import '../email/provider/verify_email_provider.dart';
import '../pre_login/sign_in/sign_in_page.dart';
import '../pre_login/sign_in/sign_in_provider.dart';



class AppRoutes {
  static final routes = [
    getx.GetPage(
      name: '/welcome',
      page: () => WelcomeProvider(
        child: WelcomePage(),
      ),
    ),
    getx.GetPage(
      name: '/sign_in',
      page: () => SignInProvider(
        child: SignInPage(),
      ),
    ),
    getx.GetPage(
      name: '/get_mail_code',
      page: () => GetEmailCodeProvider(
        child: GetMailCodePage(),
      ),
    ),
    getx.GetPage(
      name: '/verify_email',
      page: () {
        final args = getx.Get.arguments as Map<String, dynamic>;
        return VerifyEmailPage(
          email: args['email'],
          verificationKey: args['verificationKey'],
        );
      },
    ),
    getx.GetPage(
      name: '/verify_success',
      page: () {
        final args = getx.Get.arguments as Map<String, dynamic>;
        return VerifySuccessPage(
          message: args['message'] ?? '',
        );
      },
    ),
    getx.GetPage(
      name: '/sign_up',
      page: () => SignUpPage(),
    ),
  ];
}