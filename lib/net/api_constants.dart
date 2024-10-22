import 'dart:convert' as convert;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import '../constants/constant_data.dart';
import '../utils/shared_preference_util.dart';

class ApiConstants{
  static ApiConstants get instance => ApiConstants();
  static bool useVoicesDating = false;
  static const timeoutSec = 30;

  static const String debugUrl = "https://api.masonvips.com";
  static const String productionUrl  = "https://www.masonvips.com/";
  static const String wsDebugUrl = "wss://chat.masonvips.com/ws";

  static const String voicesDatingDebugUrl= "https://api.voicesdating.com";
  static const String voicesDatingProductionUrl = "https://www.voicesdating.com/";
  static const String wsVoicesDatingDebugUrl = "wss://chat.voicesdating.com/ws";

  static const String debugCheckId = "Fi5cahyee7ta8iemaecee9Oe3eithia2";//"Joh0ziebob5iuvo1koozaebiagaeD2zo";//"Fi5cahyee7ta8iemaecee9Oe3eithia2";
  static const String urlVersion = "/v1";

  static const String releaseUrl ="https://api.sweetpartnerapp.com";
  static const String wsReleaseUrl = "wss://chat.sweetpartnerapp.com/ws";


  static const String releaseMainUrl = kReleaseMode?"https://api.sdmapp.co":debugUrl;
  static const String wsReleaseMainUrl = kReleaseMode?"wss://chat.sdmapp.co/ws":wsDebugUrl;

  static const String privacyPolicy = "https://www.sweetpartnerapp.com/privacyPolicy";
  static const String termOfUse = "https://www.sweetpartnerapp.com/serviceAgreement";
  static const String privacyPolicyMain = "https://www.sdmapp.co/privacyPolicy";
  static const String termOfUseMain = "https://www.sdmapp.co/serviceAgreement";


  static const String androidDebugAppId = "fed327531298e7f863cdf2c2ad0903e9";
  static const String androidDebugSecret = "0013ce26-7219-b304-1d18-072c46c0aab2";

  static const String voicesDatingAppId = "699010ebcf61c7d459bcce7aa789efc6";
  static const String voicesDatingAppSecret  ="4568eea9-dd84-31b5-0a04-45efad009df2";

  static const String androidReleaseAppId = "d9408842a3e6b1a7c7e851a5421ad49f";
  static const String androidReleaseSecret = "abf5b917-a7c5-804e-2796-75b0185a932f";

  static const String iosAppId = "f1984b7ac8e487ba6a84587abfbea9c5";
  static const String iosAppSecret = "dbb83743-c6b4-8ae5-5be4-cc60e25030ca";

  static const String iosReleaseAppId = "8765adf2e0e842c3c0bf6bc666b0f482";
  static const String iosReleaseSecret = "213247d3-ad4e-0a19-684e-26280a0152ef";

  static const String iosNewTargetId = "235074a36a35b818fd47d1285e917675";
  static const String iosNewTargetSecret = "d19936e1-964e-99d6-b2ab-6528daef2f9c";


  static const String accessToken = "$urlVersion/access_token";

  static const String checkUserName = "$urlVersion/check_username";
  static const String checkEmail = "$urlVersion/check_email";
  static const String currentLocation = "$urlVersion/current_location";
  static const String emailVerificationCode = "$urlVersion/email_verification_code";
  static const String signUP = "$urlVersion/signup";
  static const String signIn = "$urlVersion/signin";
  static const String signOut = "$urlVersion/signout";
  static const String uploadPicture = "$urlVersion/upload_picture";
  static const String uploadFile = "$urlVersion/upload_file";
  static const String forgetPassword = "$urlVersion/forget_password";
  static const String resetPwd = "$urlVersion/reset_password";
  static const String changePwd = "$urlVersion/change_password";
  static const String changeUserName = "$urlVersion/change_username";
  static const String changeEmail = "$urlVersion/change_email";
  static const String feedback = "$urlVersion/feedback";
  static const String resign = "$urlVersion/resign";
  static const String updateProfile = "$urlVersion/update_profile";
  static const String getProfile = "$urlVersion/get_profile";
  static const String search = "$urlVersion/search";
  static const String likeUser = "$urlVersion/like_user";
  static const String passUser = "$urlVersion/pass_user";
  static const String cancelLikeUser = "$urlVersion/cancel_like_user";
  static const String likedUser = "$urlVersion/liked_users";
  static const String likeMeUser = "$urlVersion/likedme_users";
  static const String passedUser = "$urlVersion/passed_users";
  static const String visiteMeUsers = "$urlVersion/visitedme_users";
  static const String blockedUsers = "$urlVersion/blocked_users";
  static const String deletePhoto = "$urlVersion/delete_photo";
  static const String setAvatar = "$urlVersion/set_avatar";
  static const String getAvatar = "$urlVersion/get_avatar";
  static const String chattedUsers = "$urlVersion/chatted_users";
  static const String newMessages = "$urlVersion/new_messages";
  static const String historyMessages = "$urlVersion/history_messages";
  static const String deleteConversation = "$urlVersion/delete_conversation";
  static const String blockUser = "$urlVersion/block_user";
  static const String unblockUser = "$urlVersion/unblock_user";
  static const String newBadges = "$urlVersion/new_badges";
  static const String deleteNew = "$urlVersion/delete_new";
  static const String setVisibility = "$urlVersion/set_visibility";
  static const String setNotification = "$urlVersion/set_notification";
  static const String reportItems = "$urlVersion/report_items";
  static const String reportUser = "$urlVersion/report_user";
  static const String uploadTimeline = "$urlVersion/upload_timeline";
  static const String delTimeline = "$urlVersion/del_timeline";
  static const String timelines = "$urlVersion/timelines";
  static const String likeTimeline = "$urlVersion/like_timeline";
  static const String cancelLikeTimeline = "$urlVersion/cancel_like_timeline";
  static const String verifyIosPayment = "$urlVersion/verify_ios_payment";
  static const String verifyAndroidPayment = "$urlVersion/verify_android_payment";
  static const String productionList = "$urlVersion/production_list";
  static const String checkChat = "$urlVersion/can_chat";
  static const String paymentSubscriptions = "$urlVersion/payment_subscriptions";
  static const String changePhotoType = "$urlVersion/change_photo_type";
  static const String requestPrivateAlbum = "$urlVersion/request/private/album";
  static const String acceptPrivateAlbum = "$urlVersion/accept/private/album";
  static const String rejectPrivateAlbum = "$urlVersion/reject/private/album";
  static const String requestedPrivateAlbum = "$urlVersion/who/requested/private/album";
  static const String accessedPrivateAlbum = "$urlVersion/who/accessed/private/album";
  static const String getWinkItem = "$urlVersion/wink/type/list";
  static const String setWinkedUser = "$urlVersion/set_winked_user";
  static const String winkedMeUser = "$urlVersion/winked_me_users";
  static const String funUnansweredList = "$urlVersion/fun_question/un_answered_list";
  static const String funAnsweredList = "$urlVersion/fun_question/answered_list";
  static const String funSave = "$urlVersion/fun_question/save";
  static const String funUpdate = "$urlVersion/fun_question/update";
  static const String getTimelineLikes = "$urlVersion/get/timeline/likes";
  static const String getTimelineComments = "$urlVersion/get/timeline/comments";
  static const String addTimelineComment = "$urlVersion/add/timeline/comment";
  static const String myQuestionPost = "$urlVersion/my/question/post";
  static const String myQuestionDelete = "$urlVersion/my/question/delete";
  static const String myQuestionAnswer= "$urlVersion/my/question/answer";
  static const String myQuestionAnswers= "$urlVersion/my/question/answers";
  static const String myQuestionList = "$urlVersion/my/question/list";
  static const String myQuestionUpdate = "$urlVersion/my/question/views/update";
  static const String questionRecommend= "$urlVersion/question/recommend";
  static const String questionAnswers = "$urlVersion/question/answers";
  static const String appleSign = "$urlVersion/apple/signin";
  static const String createProfileVideo = "$urlVersion/profile/video/create";
  static const String uploadVoice = "$urlVersion/voice/upload";

  static const String getProfileOptions = "$urlVersion/profile_options";
  static const String verifyEmail = "$urlVersion/verify_email";
  static const String getRandomUser = "$urlVersion/get/random/users";
  static const String setMatchUser = "$urlVersion/set/matched/users";
  static const String likeTimelineComment = "$urlVersion/like/timeline/comment";

  static const String getCityList = "$urlVersion/city_list";
  static const String googleSign = "$urlVersion/google/signin";
  static const String updateUserLocation = "$urlVersion/set/user/location";
  static const String recaptchaVerify = "$urlVersion/recaptcha/verify";
  static const String deleteVoice = "$urlVersion/voice/delete";
  static const String contactSetTop = "$urlVersion/chat/set/top";
  static const String contactCancelTop = "$urlVersion/chat/cancel/top";
  static const String enableAccount = "$urlVersion/enable/account";
  static const String profileVideoVerify = "$urlVersion/profile/video/verify";
  static const String apiGetCountryList = "$urlVersion/country_list";
  static const String apiGetStateList = "$urlVersion/state_list";
  static const String apiFaqList = "$urlVersion/faq/list";
  static const String notificationForEach = "$urlVersion/notification/foreach";
  static const String getNotification = "$urlVersion/get/notification";
  static const String postMoment = "$urlVersion/post_timeline";
  static const String getLanguageMatchInfo = "$urlVersion/language/match/info";
  static const String verifyApplePurchase = "$urlVersion/verify_ios_payment";
  static const String disableAccount = "$urlVersion/disable/account";
  static const String getTimelineById = "$urlVersion/timeline";
  static const String checkJoinMain = "$urlVersion/check/join/main";
  static const String syncAccount = "$urlVersion/sync/account";
  static const String syncSignIn = "$urlVersion/sync/signin";
  static const String universalPopup = "$urlVersion/universal/popup";
  static const String getS3UploadUrl = "$urlVersion/s3/uploading/signed/url";
  static const String getReplaceWords = "$urlVersion/get/replace/words";
  static const String readMessage ="$urlVersion/read/message";
  static const String winkTypeList = "$urlVersion/wink/type/list";
  static const String confirmPassword = "$urlVersion/confirm_password";
  static const String deleteAccount = "$urlVersion/delete/account";

  // static String baseUrl = kReleaseMode?debugUrl:debugUrl;
  //
  // static String wsUrl = kReleaseMode?wsDebugUrl:wsDebugUrl;

  static getBaseUrl(){
    return useVoicesDating ? voicesDatingDebugUrl : debugUrl;

  }

  static getWsUrl(){
    return useVoicesDating ? wsVoicesDatingDebugUrl :wsDebugUrl;

  }

  static String get appId {
    //var openMain = SharedPreferenceUtil().getValue(key: SharedPresKeys.isOpenToMain)??false;
    return useVoicesDating ? voicesDatingAppId : androidDebugAppId;

  }

  static String get appSecret{
    //var openMain = SharedPreferenceUtil().getValue(key: SharedPresKeys.isOpenToMain)??false;
    return useVoicesDating ? voicesDatingAppSecret : androidDebugSecret;

  }

  static String getTnc({bool showMain = false}){
    var openMain = SharedPreferenceUtil().getValue(key: SharedPresKeys.isOpenToMain)??false;
    if(openMain||showMain){
      return termOfUseMain;
    }else{
      return termOfUse;
    }
  }

  static String getPrivacy({bool showMain = false}){
    var openMain = SharedPreferenceUtil().getValue(key: SharedPresKeys.isOpenToMain)??false;
    if(openMain||showMain){
      return privacyPolicyMain;
    }else{
      return privacyPolicy;
    }
  }

  String encodeBase64(String data) {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  String decodeBase64(String data) {
    List<int> bytes = convert.base64Decode(data);
    String result = convert.utf8.decode(bytes);
    return result;
  }

}