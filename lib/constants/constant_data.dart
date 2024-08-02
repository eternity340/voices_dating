import 'package:flutter_screenutil/flutter_screenutil.dart';

class SharedPresKeys {
  static const fireToken = "fireToken";
  static const userToken = "userToken";
  static const isLogin = "isLogin";
  static const localProfileOptions = "localProfileOptions";
  static const searchFilterData = "searchFilter";
  static const sparkFilterData = "sparkFilter";
  static const latitude = "latitude";
  static const longitude = "longitude";
  static const selfEntity = "selfEntity";
  static const reportData = "reportData";
  static const cityData = "cityData";
  static const appleEmail = "appleEmail";
  static const downloadedLanguage = "downloadedLanguage";
  static const autoTranslate = "autoTranslate";
  static const primaryLanguage = "primaryLanguage";
  static const viewRecommendUserCount = "viewRecommendUserCount";
  static const isOpenToMain = "isOpenToMain";
}

class ConstantData {
  static final successResponseCode = [200, 201, 202, 203, 204, 205, 206];

  static const code = "code";
  static const message = "message";
  static const data = "data";

  static const int genderTypeMen = 2;
  static const int genderTypeWomen = 1;

  static const String keyAnyWhere = "Anywhere";

  static const sortDistance = "Distance";
  static const String sortLastLogin = "Last login";
  static const String sortNewest = "Newest";
  static const String sortSmart = "Smart";

  static const double maxMessageImageSize = 200;

  static const errorTokenInvalid = 2000110;
  static const errorRefreshToken = 2000116;
  static const errorAccountSuspended = 30001055;
  static const errorNeedRecaptcha = 30001051;
  static const errorUserHidden = 30001024;
  static const errorUserBlockMe = 30001033;
  static const errorUserUnavailable = 30001029;
  static const errorEmailExists = 30001018;
  static const errorUserInactive = 30001021;
  static const errorCodeInvalidEmailOrPassword = 30001013;

  //get route params
  static const paramsUserId = "userId";
  static const paramsEmail = "email";
  static const paramsPwd = "pwd";
  static const paramsUserName = "userName";
  static const paramsSignKey = "signKey";
  static const paramsIndex = "index";
  static const paramsIsLogin = "isLogin";
  static const paramsUrl = "url";
  static const paramsTitle = "title";
  static const appleToken = "appleToken";
  static const appleCode = "appleCode";

  static const int photoTypePublic = 1;
  static const int photoTypePrivate = 2;
  static const int photoTypeVerify = 3;

  static const double maxAssetImageWidth = 1920;
  static const double maxAssetImageHeight = 1080;

  static double defaultAvatarSize = 48.w;

  static const googleHelpCenter = "https://support.google.com/googleplay/answer/2476088?hl=en&ref_topic=1689236";

  static const String serviceAgreementUrl = "";
  static const String privacyPolicyUrl = "";

  static const userStatusNotVerify = "0";
  static const userStatusVerified = "1";
  static const userStatusPending = "2";
  static const userStatusReject = "3";
  static const userStatusPendingCanUpload = "4";

  static const activityVideo = "11";
  static const activityAudio = "19";

  static const lastImageMsg = "[Image]";
  static const lastWinkMsg = "[Wink]";

  static const funQuestion = "funQuestion";
  static const userQuestion = "myQuestion";

  static final normalBtnWidth = 312.w;
  static final normalBtnHeight = 54.w;

  static const notificationComment = "11";
  static const notificationReply = "20";

  static const honeyOption = 'Honey';
  static const nearbyOption = 'Nearby';
  static const honeyPageContent = 'Honey Page Content';
  static const nearbyPageContent = 'Nearby Page Content';

  //fontStyle
  static const fontPoppins = 'Poppins';
  static const fontOpenSans ='Open Sans';
  //background
  static const backText = 'Back';
  static const saveText = 'Save';
  //bottom_options
  static const CancelText = 'Cancel';
  //custom_message_dialog
  static const cancelText = 'cancel';
  static const yesText='Yes';
  //detail_bottom_bar
  static const likeText='like';
  //get_email_code
  static const  welcomeText = "Welcome";
  static const  enterEmailText = "Please enter your email";
  static const  emailLabelText = "Email";
  static const  nextButtonText = "Next";
  //verify_email
  static const  verifyCodeTitle = "Verify Code";
  static const  verifyCodeSubtitle = "Enter the verify code sent to your email";
  static const  resendCode = "Resend Code";
  static const  timerText = "s resend code";
  static const  verifyButtonText = "Verify";
  //verify_success
  static const  emailVerificationSuccess = "Email verification successful!";
  static const  emailVerificationSuccessMessage = "Your email has been successfully verified.";
  //select_birthday
  static const  birthdayTitle = "Birthday";
  static const  continueButtonText = "Continue";
  //select_gender
  static const  genderTitle = "Gender";
  static const  maleOption = "Male";
  static const  femaleOption = "Female";
  static const  genderWarning = "Gender cannot be changed after selection";
  //select_height
  static const  heightTitle = "Height";
  //select_location
  static const  locationTitle = "Location";
  //sign_up
  static const  nicknameTitle = "Set a nickname";
  static const  passwordTitle = "Set a password";
  static const  submitButtonText = "Submit";
  static const  signUpText ="Sign Up";
  //sign_in
  static const  enterYourEmail = "Enter your email";
  static const  enterPasswordText = "Enter your password";
  static const  forgetPassword = "Forget Password?";
  static const  signInText ="Sign In";
  //profile_card
  static const  photosVerified = 'Photos verified';
  //feel_page
  static const  feelTitleText ='       Feel';
  //profile_detail
  static const  headline = 'Headline';
  static const  moments = 'Moments';
  static const  aboutMe = 'About Me';
  static const  chatButton = 'Chat';
  //home_page
  static const String feelLabel = 'Feel';
  static const String getUpLabel = 'Get up';
  static const String gameLabel = 'Game';
  static const String gossipLabel = 'Gossip';
}
