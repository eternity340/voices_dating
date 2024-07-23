
import 'package:first_app/pages/me/my_profile/update_profile/change_username/change_username.dart';
import 'package:first_app/pages/me/photo/photo_page.dart';
import 'package:first_app/pages/me/settings/about_me/about_me_page.dart';
import 'package:first_app/pages/me/settings/block_member/block_member_page.dart';
import 'package:first_app/pages/me/settings/feedback/feedback_page.dart';
import 'package:first_app/pages/me/settings/purchase_record/purchase_record_page.dart';
import 'package:first_app/pages/me/verify/verify_page.dart';
import 'package:first_app/pages/moments/moments_detail/moments_detail_page.dart';
import 'package:first_app/pages/voice/voice_page.dart';
import 'package:get/get.dart' as getx;
import '../pages/email/page/get_email_code_page.dart';
import '../pages/email/page/verify_email_page.dart';
import '../pages/email/page/verify_success_page.dart';
import '../pages/email/provider/get_email_code_provider.dart';
import '../pages/home/home_page.dart';
import '../pages/me/me_page.dart';
import '../pages/me/my_profile/update_profile/change_age/change_age.dart';
import '../pages/me/my_profile/update_profile/change_headline/change_headline.dart';
import '../pages/me/my_profile/update_profile/change_height/change_height.dart';
import '../pages/me/my_profile/my_profile_page.dart';
import '../pages/me/my_profile/update_profile/change_location/change_location.dart';
import '../pages/me/notification/notification_page.dart';
import '../pages/me/settings/settings_page.dart';
import '../pages/me/verify/verify_ID/verify_ID_page.dart';
import '../pages/me/verify/verify_photo/verify_photo_page.dart';
import '../pages/moments/moments_page.dart';
import '../pages/pre_login/forget_pwd/forget_pwd_page.dart';
import '../pages/pre_login/forget_pwd/forget_pwd_provider.dart';
import '../pages/pre_login/sign_in/sign_in_provider.dart';
import '../pages/pre_login/sign_up/components/location_detail.dart';
import '../pages/pre_login/sign_up/display_userinfo_page.dart';
import '../pages/pre_login/sign_up/select_birthday_page.dart';
import '../pages/pre_login/sign_up/select_gender_page.dart';
import '../pages/pre_login/sign_up/select_height_page.dart';
import '../pages/pre_login/sign_up/select_location_page.dart';
import '../pages/pre_login/sign_up/sign_up_page.dart';
import '../pages/pre_login/welcome/welcome_page.dart';
import '../pages/pre_login/welcome/welcome_provider.dart';
import '../pages/pre_login/sign_in/sign_in_page.dart';
import '../entity/User.dart';


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
      page: () => const SignInProvider(
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
    getx.GetPage(name: '/select_height', page: () {
      final user = getx.Get.arguments as User;
      return SelectHeightPage(user: user);
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
    getx.GetPage(
      name: '/home',
      page: () => HomePage(),
    ),
    getx.GetPage(
      name: '/moments',
      page: () => MomentsPage(),
      children: [
        getx.GetPage(
          name: '/moments_detail',
          page: () => MomentsDetailPage(),
        ),
      ],
    ),
    getx.GetPage(
      name: '/voice',
      page: () => VoicePage(),
    ),
    getx.GetPage(
      name: '/me',
      page: () => MePage(),
      children: [
        getx.GetPage(
          name: '/photo',
          page: () => PhotoPage(),
        ),
        getx.GetPage(
          name: '/my_profile',
          page: () => MyProfilePage(),
          children: [
            getx.GetPage(
              name: '/change_username',
              page: () => ChangeUsername(),
            ),
            getx.GetPage(
              name: '/change_age',
              page: () => ChangeAge(),
            ),
            getx.GetPage(
              name: '/change_headline',
              page: () => ChangeHeadline(),
            ),
            getx.GetPage(
              name: '/change_height',
              page: () => ChangeHeight(),
            ),
            getx.GetPage(
              name: '/change_location',
              page: () => ChangeLocation(),
              children: [
                getx.GetPage(
                  name: '/change_location_detail',
                  page: () => ChangeLocation(),
                ),
              ]
            ),
          ],
        ),
        getx.GetPage(
          name: '/verify',
          page: ()=> VerifyPage(),
          children: [
            getx.GetPage(
                name: '/verify_photo',
                page: ()=>VerifyPhotoPage(),
            ),
            getx.GetPage(
              name: '/verify_ID',
              page: ()=>VerifyIDPage(),
            ),
          ],
        ),
        getx.GetPage(
          name: '/settings',
          page: () => SettingsPage(),
          children: [
            getx.GetPage(
              name: '/block_member',
              page: () => BlockMemberPage(),
            ),
            getx.GetPage(
              name: '/feedback',
              page: () => FeedbackPage(),
            ),
            getx.GetPage(
              name: '/purchase_record',
              page: () => PurchaseRecordPage(),
            ),
            getx.GetPage(
              name: '/about_me',
              page: () => AboutMePage(),
            ),
          ],
        ),
        getx.GetPage(
          name: '/notification',
          page: () => NotificationPage(),
        ),
      ],
    ),

  ];
}
