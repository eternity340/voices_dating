import 'dart:convert';
import 'dart:io';

import 'package:first_app/service/token_service.dart';
import 'package:get/get.dart';
import 'package:plain_notification_token/plain_notification_token.dart';
import 'package:first_app/utils/string_extension.dart';
import 'package:first_app/utils/list_extension.dart';
import '../components/custom_navigate_widget.dart';
import '../constants/constant_data.dart';
import '../entity/badge_entity.dart';
import '../entity/chatted_user_entity.dart';
import '../entity/language_match_info_entity.dart';
import '../entity/report_reason_item_entity.dart';
import '../entity/user_data_entity.dart';
import '../net/api_constants.dart';
import '../net/dio.client.dart';
import '../utils/common_utils.dart';
import '../utils/log_util.dart';
import '../utils/request_util.dart';
import '../utils/shared_preference_util.dart';
import '../utils/string_extension.dart';
import 'im_service.dart';



//Edit by Connor - 用于全局处理用户个人的相关业务
class AppService extends GetxService{

  static AppService get instance => Get.find<AppService>();

  UserDataEntity? selfUser;
  bool isLogin = false;
  var canShowAsyncTip = false;

  var badgeEntity = BadgeEntity().obs;
  var languageMatchInfo = LanguageMatchInfoEntity().obs;

  var badgeRetryTime = 0;
  List<ReportReasonEntity> reportReasonList = [];
  final plainNotificationToken = PlainNotificationToken();



  Future<AppService> init() async{
    if(selfUser==null){
      String? userJson = SharedPreferenceUtil.instance.getValue(key: SharedPresKeys.selfEntity);
      if(userJson.hasData){
        LogUtil.d(message: "user:$userJson");
        selfUser = UserDataEntity.fromJson(json.decode(userJson!));
      }else{
        LogUtil.d(message: "userJson empty");

      }
    }
    return this;
  }

  saveUserData({required UserDataEntity userData}){
    selfUser = userData;
    SharedPreferenceUtil.instance.setValue(key: SharedPresKeys.selfEntity, value: userData.toString());
  }

  bool isMember(){
    int memberStatus = int.parse(selfUser?.member??"0");

    return memberStatus>=1;
  }

  forceLogout({bool isDelete = false}) async{
    isLogin = SharedPreferenceUtil.instance.getValue(key: SharedPresKeys.isLogin)??false;

    LogUtil.d(message: "logout:$isLogin");
    if(isLogin){
      SharedPreferenceUtil.instance.setValue(key: SharedPresKeys.isLogin, value: false);
      WfCommonUtils.showLoading();
      DioClient.instance.cancelAllRequest();
      await IMService.instance.disconnect();
      if(!isDelete) {
        await DioClient.instance.requestNetwork(url: ApiConstants.signOut);
      }
      TokenService.instance.clearToken();
      WfCommonUtils.hideLoading();
    }

    SharedPreferenceUtil.instance.setValue(key: SharedPresKeys.selfEntity, value: "");
    Get.offAllNamed('/welcome');
  }

  syncSelfProfile() async{
    if(selfUser==null){
      forceLogout();
      return;
    }
    Map<String,dynamic> params = RequestUtil.getUserProfileMap(userId: selfUser!.userId!);
    DioClient.instance.requestNetwork<UserDataEntity>(url: ApiConstants.getProfile,method: Method.get,queryParameters: params,
        onSuccess: (result){
          if(result!=null){
            saveUserData(userData: result);
          }
        }
    );
  }

  // viewProfile({required String userId}){
  //   Map<String,String> params = {};
  //   params.putIfAbsent(ConstantData.paramsUserId, () => userId);
  //   Get.toNamed(WfRoutes.userProfile,parameters: params);
  // }

  void requestNewBadges() {
    Map<String, dynamic> requestMap = {};
    DioClient.instance.requestNetwork<BadgeEntity>(
      url: ApiConstants.newBadges,method: Method.get,
      queryParameters: requestMap,
      onSuccess: (data) {
        if(data!=null) {
          badgeEntity.value = data;
        }
      },
      onError: (code,message,data){
        Future.delayed(const Duration(seconds: 2),(){
          if(badgeRetryTime<2) {
            badgeRetryTime++;
            requestNewBadges();
          }
        });
      },
    );
  }

  getLanguageMatchInfo(){
    Map<String, dynamic> requestMap = {};
    DioClient.instance.requestNetwork<LanguageMatchInfoEntity>(
      url: ApiConstants.getLanguageMatchInfo,method: Method.get,
      queryParameters: requestMap,
      onSuccess: (data) {
        LogUtil.d(message: "matchinfo:${data}");
        if(data!=null) {
          languageMatchInfo.value = data;
        }
      },

    );
  }


  getReportItems(){
    DioClient.instance.requestNetwork<List<ReportReasonEntity>>(url: ApiConstants.reportItems,method: Method.get,
        onSuccess: (result){
          if(!result.isNullOrEmpty){
            reportReasonList.clear();
            reportReasonList.addAll(result!);
            LogUtil.d(message: "report:${reportReasonList.length}");
          }
        }
    );
  }

  chatUser({required UserDataEntity userDataEntity}){
    ChattedUserEntity item = ChattedUserEntity.fromJson(userDataEntity.toJson());
    //Get.toNamed(WfRoutes.singleConversationPage,arguments: item);
  }

  // checkShowAsyncPop({bool immediately = false}){
  //   if(!canShowAsyncTip||selfUser!.appleTag==true) {
  //     return false;
  //   }
  //
  //   var viewCount = SharedPreferenceUtil.instance.getValue(key: SharedPresKeys.viewRecommendUserCount)??0;
  //
  //   if(immediately||viewCount>3){
  //     Get.dialog(CustomNavigateWidget(onConfirmTap: (){
  //       Get.back();
  //       asyncUserAccount();
  //     }, gender: 1,));
  //     return true;
  //   }
  //   return false;
  // }

  Future<bool> asyncUserAccount() async{
    bool status = false;
    WfCommonUtils.showLoading();
    await DioClient.instance.requestNetwork<Map>(url: ApiConstants.syncAccount,onSuccess: (result){
      if(result!=null){
        LogUtil.d(message: "async account:${result}");
        var key = result["key"];
        if(key!=null) {
          WfCommonUtils.hideLoading();
          restartApp(key);
        }
      }
    },onError: (code,message,data){
      // SharedPreferenceUtil.instance.setValue(key: SharedPresKeys.isOpenToMain, value: false);
      WfCommonUtils.hideLoading();
      // restartApp("abcd");

    });

    return status;
  }



  restartApp(String key){
    Get.offAllNamed('/welcome');
  }

  initPushToken() async{
    if (Platform.isIOS) {
      plainNotificationToken.requestPermission();

      // If you want to wait until Permission dialog close,
      // you need wait changing setting registered.
      await plainNotificationToken.onIosSettingsRegistered.first;
      final String? token = await plainNotificationToken.getToken();
      if(token!=null){
        LogUtil.d(message: "pushtoken:$token");
        SharedPreferenceUtil().setValue(key: SharedPresKeys.fireToken, value: token);
      }
    }


  }

}