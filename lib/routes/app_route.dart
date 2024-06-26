import 'package:get/get.dart' as getx;
import '../entity/User.dart';
import '../pages/email/page/get_email_code_page.dart';
import '../pages/email/page/verify_email_page.dart';
import '../pages/email/page/verify_success_page.dart';
import '../pages/email/provider/get_email_code_provider.dart';
import '../pages/pre_login/forget_pwd/forget_pwd_page.dart';
import '../pages/pre_login/forget_pwd/forget_pwd_provider.dart';
import '../pages/pre_login/sign_in/sign_in_provider.dart';
import '../pages/pre_login/sign_up/components/location_detail.dart';
import '../pages/pre_login/sign_up/display_userinfo_page.dart';
import '../pages/pre_login/sign_up/select_birthday_page.dart';
import '../pages/pre_login/sign_up/select_gender_page.dart';
import '../pages/pre_login/sign_up/select_location_page.dart';
import '../pages/pre_login/sign_up/sign_up_page.dart';
import '../pages/pre_login/welcome/welcome_page.dart';
import '../pages/pre_login/welcome/welcome_provider.dart';
import '../pages/pre_login/sign_in/sign_in_page.dart';



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
    getx.GetPage(name: '/verify_email', page: () {
      final args = getx.Get.arguments as Map<String, dynamic>;
      return VerifyEmailPage(
        email: args['email'],
        verificationKey: args['verificationKey'],
      );
    }),
    getx.GetPage(name: '/verify_success', page: () {
      final args = getx.Get.arguments as Map<String, dynamic>;
      return VerifySuccessPage(
        message: args['message'],
        user: args['user'],
      );
    }),
    getx.GetPage(
      name: '/forget_pwd',
      page: () => const ForgetPwdProvider(
        child: ForgetPwdPage(),
      ),
    ),
    getx.GetPage(name: '/select_gender', page: () {
      final user = getx.Get.arguments as User;
      return SelectGenderPage(user: user);
    }),
    getx.GetPage(name: '/select_location', page: () {
      final user = getx.Get.arguments as User;
      return SelectLocationPage(user: user);
    }),
    getx.GetPage(name: '/select_birthday', page: () {
      final user = getx.Get.arguments as User;
      return SelectBirthdayPage(user: user);
    }),
    getx.GetPage(
      name: '/sign_up',
      page: () {
        final user = getx.Get.arguments as User;
        return SignUpPage(user: user);
      },
    ),
    getx.GetPage(
      name: '/display_user_info',
      page: () {
        return DisplayUserInfoPage();
      },
    ),
    // 添加 location_detail 页面
    getx.GetPage(name: '/location_detail', page: () {
      final user = getx.Get.arguments as User;
      return LocationDetailPage(user: user);
    }),
  ];
}
