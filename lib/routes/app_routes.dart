import 'package:voices_dating/pages/home/filters/filters_page.dart';
import 'package:voices_dating/pages/home/feel/feel_page.dart';
import 'package:voices_dating/pages/home/game/game_page.dart';
import 'package:voices_dating/pages/home/get_up/get_up_page.dart';
import 'package:voices_dating/pages/home/gossip/gossip_page.dart';
import 'package:voices_dating/pages/home/profile_detail/profile_detail_page.dart';
import 'package:voices_dating/pages/home/user_profile/user_moments/user_moments_page.dart';
import 'package:voices_dating/pages/home/user_profile/user_profile_page.dart';
import 'package:voices_dating/pages/home/user_profile/user_report/user_report_page.dart';
import 'package:voices_dating/pages/me/host/host_page.dart';
import 'package:voices_dating/pages/me/my_profile/update_profile/change_username/change_username.dart';
import 'package:voices_dating/pages/me/my_profile/update_profile/upload_voice/record/record_page.dart';
import 'package:voices_dating/pages/me/my_profile/update_profile/upload_voice/upload_voice_page.dart';
import 'package:voices_dating/pages/me/photo/photo_page.dart';
import 'package:voices_dating/pages/me/settings/about_me/about_me_page.dart';
import 'package:voices_dating/pages/me/settings/block_member/block_member_page.dart';
import 'package:voices_dating/pages/me/settings/feedback/feedback_page.dart';
import 'package:voices_dating/pages/me/settings/purchase_record/purchase_record_page.dart';
import 'package:voices_dating/pages/me/verify/verify_page.dart';
import 'package:voices_dating/pages/message/private_chat/private_chat_page.dart';
import 'package:voices_dating/pages/moments/add_moment/add_moment_page.dart';
import 'package:voices_dating/pages/moments/moments_detail/moments_detail_page.dart';
import 'package:voices_dating/pages/voice/voice_page.dart';
import 'package:get/get.dart' as getx;
import '../pages/email/page/get_email_code_page.dart';
import '../pages/email/page/verify_email_page.dart';
import '../pages/email/page/verify_success_page.dart';
import '../pages/home/filters/filters_search/filters_search_page.dart';
import '../pages/home/home_page.dart';
import '../pages/home/profile_detail/profile_moments/profile_moments_page.dart';
import '../pages/home/profile_detail/report/report_page.dart';
import '../pages/me/me_page.dart';
import '../pages/me/my_profile/update_profile/change_age/change_age.dart';
import '../pages/me/my_profile/update_profile/change_headline/change_headline.dart';
import '../pages/me/my_profile/update_profile/change_height/change_height.dart';
import '../pages/me/my_profile/my_profile_page.dart';
import '../pages/me/my_profile/update_profile/change_location/change_location.dart';
import '../pages/me/my_profile/update_profile/change_location/components/location_detail.dart';
import '../pages/me/notification/notification_page.dart';
import '../pages/me/settings/settings_page.dart';
import '../pages/me/verify/verify_video/verify_video_page.dart';
import '../pages/me/verify/verify_photo/verify_photo_page.dart';
import '../pages/message/message_page.dart';
import '../pages/moments/moments_page.dart';
import '../pages/pre_login/forget_pwd/forget_pwd_page.dart';
import '../pages/pre_login/sign_in/sign_in_provider.dart';
import '../pages/pre_login/sign_up/components/location_detail.dart';
import '../pages/pre_login/sign_up/select_birthday_page.dart';
import '../pages/pre_login/sign_up/select_gender_page.dart';
import '../pages/pre_login/sign_up/select_height_page.dart';
import '../pages/pre_login/sign_up/select_location_page.dart';
import '../pages/pre_login/sign_up/sign_up_page.dart';
import '../pages/pre_login/welcome/welcome_page.dart';
import '../pages/pre_login/sign_in/sign_in_page.dart';
import '../entity/User.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String signIn = '/sign_in';
  static const String getMailCode = '/get_mail_code';
  static const String verifyEmail = '/verify_email';
  static const String verifySuccess = '/verify_success';
  static const String forgetPwd = '/forget_pwd';
  static const String selectGender = '/select_gender';
  static const String selectLocation = '/select_location';
  static const String selectBirthday = '/select_birthday';
  static const String selectHeight = '/select_height';
  static const String signUp = '/sign_up';
  static const String locationDetail = '/location_detail';
  static const String home = '/home';
  static const String profileDetail = '/profile_detail';
  static const String profileMoments = '/profile_moments';
  static const String report = '/report';
  static const String feel = '/feel';
  static const String getUp = '/get_up';
  static const String game = '/game';
  static const String gossip = '/gossip';
  static const String filters = '/filters';
  static const String filtersSearch = '/filters_search';
  static const String moments = '/moments';
  static const String momentsDetail = '/moments_detail';
  static const String addMoment = '/add_moment';
  static const String voice = '/voice';
  static const String message = '/message';
  static const String privateChat = '/private_chat';
  static const String userProfile = '/user_profile';
  static const String userMoments = '/user_moments';
  static const String userReport = '/user_report';
  static const String me = '/me';
  static const String photo = '/photo';
  static const String myProfile = '/my_profile';
  static const String changeUsername = '/change_username';
  static const String changeAge = '/change_age';
  static const String changeHeadline = '/change_headline';
  static const String changeHeight = '/change_height';
  static const String changeLocation = '/change_location';
  static const String uploadVoice = '/upload_voice';
  static const String record = '/record';
  static const String verify = '/verify';
  static const String verifyPhoto = '/verify_photo';
  static const String verifyID = '/verify_ID';
  static const String settings = '/settings';
  static const String blockMember = '/block_member';
  static const String feedback = '/feedback';
  static const String purchaseRecord = '/purchase_record';
  static const String aboutMe = '/about_me';
  static const String notification = '/notification';
  static const String host = '/host';

  static const String homeProfileDetail = '$home$profileDetail';
  static const String homeProfileMoments = '$homeProfileDetail$profileMoments';
  static const String homeReport = '$homeProfileDetail$report';
  static const String homeFeel = '$home$feel';
  static const String homeGetUp = '$home$getUp';
  static const String homeGame = '$home$game';
  static const String homeGossip = '$home$gossip';
  static const String homeFilters = '$home$filters';
  static const String homeFiltersSearch = '$home$filters$filtersSearch';
  static const String momentsMomentsDetail = '$moments$momentsDetail';
  static const String momentsAddMoment = '$moments$addMoment';
  static const String messagePrivateChat = '$message$privateChat';
  static const String messageUserProfile = '$messagePrivateChat$userProfile';
  static const String messageUserMoments = '$messagePrivateChat$userMoments';
  static const String messageUserReport = '$messagePrivateChat$userReport';
  static const String mePhoto = '$me$photo';
  static const String meMyProfile = '$me$myProfile';
  static const String meVerify = '$me$verify';
  static const String meSettings = '$me$settings';
  static const String meNotification = '$me$notification';
  static const String meMyProfileChangeUsername = '$meMyProfile$changeUsername';
  static const String meMyProfileChangeAge = '$meMyProfile$changeAge';
  static const String meMyProfileChangeHeadline = '$meMyProfile$changeHeadline';
  static const String meMyProfileChangeHeight = '$meMyProfile$changeHeight';
  static const String meMyProfileChangeLocation = '$meMyProfile$changeLocation';
  static const String meMyProfileUploadVoice = '$meMyProfile$uploadVoice';
  static const String meMyProfileRecord = '$meMyProfileUploadVoice$record';
  static const String meVerifyPhoto = '$meVerify$verifyPhoto';
  static const String meVerifyID = '$meVerify$verifyID';
  static const String meSettingsBlockMember = '$meSettings$blockMember';
  static const String meSettingsFeedback = '$meSettings$feedback';
  static const String meSettingsPurchaseRecord = '$meSettings$purchaseRecord';
  static const String meSettingsAboutMe = '$meSettings$aboutMe';
  static const String meLocationDetail = '$meMyProfileChangeLocation$locationDetail';
  static const String meHost ='$me$host';


  //route transition
  static const defaultTransition = getx.Transition.cupertino;
  static const fadeTransition = getx.Transition.fade;
  static final defaultDuration = Duration(milliseconds: 300);

  static final routes = [
    getx.GetPage(
      name: welcome,
      page: () => const WelcomePage(),
      transition: defaultTransition,
      transitionDuration: defaultDuration,
    ),

    getx.GetPage(
      name: signIn,
      page: () => const SignInProvider(child: SignInPage()),
      transition: defaultTransition,
      transitionDuration: defaultDuration,
    ),

    getx.GetPage(
      name: getMailCode,
      page: () => GetMailCodePage(),
      transition: defaultTransition,
      transitionDuration: defaultDuration,
    ),

    getx.GetPage(
        name: verifyEmail,
        page: () {
      final args = getx.Get.arguments as Map<String, dynamic>;
      return VerifyEmailPage(
        email: args['email'],
        verificationKey: args['verificationKey'],
      );
    }, transition: defaultTransition,
        transitionDuration: defaultDuration),

    getx.GetPage(name: verifySuccess,
        page: () {
      final args = getx.Get.arguments as Map<String, dynamic>;
      return VerifySuccessPage(
        message: args['message'],
        user: args['user'],
      );
    }, transition: defaultTransition,
        transitionDuration: defaultDuration),

    getx.GetPage(
      name: forgetPwd,
      page: () => const ForgetPwdPage(),
      transition: defaultTransition,
      transitionDuration: defaultDuration,
    ),

    getx.GetPage(
        name: selectGender,
        page: () {
      final user = getx.Get.arguments as User;
      return SelectGenderPage(user: user);
    },
        transition: defaultTransition,
        transitionDuration: defaultDuration),

    getx.GetPage(
        name: selectLocation,
        page: () {
      final user = getx.Get.arguments as User;
      return SelectLocationPage(user: user);
    },
        transition: defaultTransition,
        transitionDuration: defaultDuration),

    getx.GetPage(name: selectBirthday, page: () {
      final user = getx.Get.arguments as User;
      return SelectBirthdayPage(user: user);
    },
        transition: defaultTransition,
        transitionDuration: defaultDuration),

    getx.GetPage(name: selectHeight, page: () {
      final user = getx.Get.arguments as User;
      return SelectHeightPage(user: user);
    },
        transition: defaultTransition,
        transitionDuration: defaultDuration),

    getx.GetPage(
        name: locationDetail,
        page: () {
          return LocationDetailPage();
        },
        transition: defaultTransition,
        transitionDuration: defaultDuration),

    getx.GetPage(
      name: signUp,
      page: () {
        final user = getx.Get.arguments as User;
        return SignUpPage(user: user);
      },
      transition: defaultTransition,
      transitionDuration: defaultDuration,
    ),


    getx.GetPage(
      name: home,
      page: () => HomePage(),
      children: [
        getx.GetPage(
          name: profileDetail,
          page: () => ProfileDetailPage(),
          transition: defaultTransition,
          transitionDuration: defaultDuration,
          children: [
            getx.GetPage(
            name: profileMoments,
            page: () =>  ProfileMomentsPage(),
            transition: defaultTransition,
            transitionDuration: defaultDuration,
          ),
            getx.GetPage(
              name: report,
              page: () =>  ReportPage(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
            ),
          ]

        ),

        getx.GetPage(
          name: feel,
          page: () => FeelPage(),
          transition: defaultTransition,
          transitionDuration: defaultDuration,
        ),

        getx.GetPage(
          name: getUp,
          page: () => GetUpPage(),
          transition: defaultTransition,
          transitionDuration: defaultDuration,
        ),

        getx.GetPage(
          name: game,
          page: () => GamePage(),
          transition: defaultTransition,
          transitionDuration: defaultDuration,
        ),
        getx.GetPage(
          name: gossip,
          page: () => GossipPage(),
          transition: defaultTransition,
          transitionDuration: defaultDuration,
        ),
        getx.GetPage(
          name: filters,
          page: () => FiltersPage(),
          transition: defaultTransition,
          transitionDuration: defaultDuration,
          children: [
            getx.GetPage(
              name: filtersSearch,
              page: () => FiltersSearchPage(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
            ),
          ]
        ),
      ],
      transition: getx.Transition.noTransition,
      transitionDuration: Duration.zero,
    ),

    getx.GetPage(
      name: moments,
      page: () => MomentsPage(),
      children: [
        getx.GetPage(
          name: momentsDetail,
          page: () => MomentsDetailPage(),
          transition: defaultTransition,
          transitionDuration: defaultDuration,
        ),
        getx.GetPage(
          name: addMoment,
          page: () => AddMomentPage(),
          transition: defaultTransition,
          transitionDuration: defaultDuration,
        ),
      ],
      transition: getx.Transition.noTransition,
      transitionDuration: Duration.zero,
    ),

    getx.GetPage(
      name: voice,
      page: () => VoicePage(),
      transition: defaultTransition,
      transitionDuration: defaultDuration,
    ),

    getx.GetPage(
      name: message,
      page: () => MessagePage(),
      children: [
        getx.GetPage(
          name: privateChat,
          page: () => PrivateChatPage(),
          children: [
            getx.GetPage(
              name: userProfile,
              page: () => UserProfilePage(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
            ),
            getx.GetPage(
              name: userMoments,
              page: () => UserMomentsPage(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
            ),
            getx.GetPage(
              name: userReport,
              page: () => UserReportPage(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
            ),
          ],
          transition: defaultTransition,
          transitionDuration: defaultDuration,
        ),
      ],
      transition: getx.Transition.noTransition,
      transitionDuration: Duration.zero,
    ),

    getx.GetPage(
      name: me,
      page: () => MePage(),
      children: [
        getx.GetPage(
          name: host,
          page: () => HostPage(),
          transition: defaultTransition,
          transitionDuration: defaultDuration,
        ),
        getx.GetPage(
          name: photo,
          page: () => PhotoPage(),
          transition: defaultTransition,
          transitionDuration: defaultDuration,
        ),
        getx.GetPage(
          name: myProfile,
          page: () => MyProfilePage(),
          children: [
            getx.GetPage(
              name: changeUsername,
              page: () => ChangeUsername(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
            ),
            getx.GetPage(
              name: changeAge,
              page: () => ChangeAge(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
            ),
            getx.GetPage(
              name: changeHeadline,
              page: () => ChangeHeadline(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
            ),
            getx.GetPage(
              name: changeHeight,
              page: () => ChangeHeight(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
            ),
            getx.GetPage(
              name: changeLocation,
              page: () => ChangeLocation(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
              children: [
                getx.GetPage(
                  name: locationDetail,
                  page: () => LocationDetail(),
                  transition: defaultTransition,
                  transitionDuration: defaultDuration,
                ),
              ],
            ),
            getx.GetPage(
              name: uploadVoice,
              page: () => UploadVoicePage(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
              children: [
                getx.GetPage(
                  name: record,
                  page: () => RecordPage(),
                  transition: defaultTransition,
                  transitionDuration: defaultDuration,
                ),
              ]
            ),
          ],
          transition: defaultTransition,
          transitionDuration: defaultDuration,
        ),
        getx.GetPage(
          name: verify,
          page: () => VerifyPage(),
          children: [
            getx.GetPage(
              name: verifyPhoto,
              page: () => VerifyPhotoPage(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
            ),
            getx.GetPage(
              name: verifyID,
              page: () => VerifyVideoPage(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
            ),
          ],
          transition: defaultTransition,
          transitionDuration: defaultDuration,
        ),
        getx.GetPage(
          name: settings,
          page: () => SettingsPage(),
          children: [
            getx.GetPage(
              name: blockMember,
              page: () => BlockMemberPage(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
            ),
            getx.GetPage(
              name: feedback,
              page: () => FeedbackPage(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
            ),
            getx.GetPage(
              name: purchaseRecord,
              page: () => PurchaseRecordPage(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
            ),
            getx.GetPage(
              name: aboutMe,
              page: () => AboutMePage(),
              transition: defaultTransition,
              transitionDuration: defaultDuration,
            ),
          ],
          transition: defaultTransition,
          transitionDuration: defaultDuration,
        ),
        getx.GetPage(
          name: notification,
          page: () => NotificationPage(),
          transition: getx.Transition.downToUp,
          transitionDuration: Duration(milliseconds: 100),
        ),
      ],
      transition: getx.Transition.noTransition,
      transitionDuration: Duration.zero,
    ),
  ];
}
