import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:voices_dating/service/token_service.dart';
import 'package:get/get.dart';
import 'package:plain_notification_token/plain_notification_token.dart';
import 'package:voices_dating/utils/list_extension.dart';
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
import 'im_service.dart';

class AppService extends GetxService {
  static AppService get instance => Get.find<AppService>();
  UserDataEntity? selfUser;
  bool isLogin = false;
  var canShowAsyncTip = false;
  final Rx<UserDataEntity?> rxSelfUser = Rx<UserDataEntity?>(null);
  var badgeEntity = BadgeEntity().obs;
  var languageMatchInfo = LanguageMatchInfoEntity().obs;
  var badgeRetryTime = 0;
  List<ReportReasonEntity> reportReasonList = [];
  final plainNotificationToken = PlainNotificationToken();

  Future<AppService> init() async {
    isLogin = await SharedPreferenceUtil.instance.getValue(key: SharedPresKeys.isLogin) ?? false;
    if (isLogin) {
      String? userJson = await SharedPreferenceUtil.instance.getValue(key: SharedPresKeys.selfEntity);
      if (userJson != null && userJson.isNotEmpty) {
        selfUser = UserDataEntity.fromJson(json.decode(userJson));
        rxSelfUser.value = selfUser;
      } else {
        isLogin = false;
        await SharedPreferenceUtil.instance.setValue(key: SharedPresKeys.isLogin, value: false);
      }
    }
    return this;
  }

  Future<void> saveUserData({required UserDataEntity userData}) async {
    selfUser = userData;
    rxSelfUser.value = userData;
    isLogin = true;
    await SharedPreferenceUtil.instance.setValue(key: SharedPresKeys.selfEntity, value: json.encode(userData.toJson()));
    await SharedPreferenceUtil.instance.setValue(key: SharedPresKeys.isLogin, value: true);
  }

  Future<void> forceLogout({bool isDelete = false}) async {
    isLogin = await SharedPreferenceUtil.instance.getValue(key: SharedPresKeys.isLogin) ?? false;
    LogUtil.d(message: "isLogin:$isLogin");
    if (isLogin) {
      await SharedPreferenceUtil.instance.setValue(key: SharedPresKeys.isLogin, value: false);
      CommonUtils.showLoading();
      DioClient.instance.cancelAllRequest();
      await IMService.instance.disconnect();
      if (!isDelete) {
        await DioClient.instance.requestNetwork(url: ApiConstants.signOut);
      }
      TokenService.instance.clearToken();
      CommonUtils.hideLoading();
    }
    await SharedPreferenceUtil.instance.setValue(key: SharedPresKeys.selfEntity, value: null);
    selfUser = null;
    isLogin = false;
    rxSelfUser.value = null;
    Get.offAllNamed('/welcome');
  }

  Future<void> syncUserData() async {
    if (!isLogin || selfUser == null) {
      LogUtil.e(message: "User not logged in or selfUser is null");
      return;
    }

    final token = await TokenService.instance.getToken();
    if (token == null) {
      LogUtil.e(message: "Failed to get token");
      return;
    }

    try {
      await DioClient.instance.requestNetwork<UserDataEntity>(
        method: Method.get,
        url: ApiConstants.getProfile,
        queryParameters: {'profId': selfUser!.userId},
        options: Options(headers: {'token': token}),
        onSuccess: (data) async {
          if (data != null) {
            await saveUserData(userData: data);
          } else {
            LogUtil.e(message: "Received null user data from server");
          }
        },
        onError: (code, msg, data) {
          LogUtil.e(message:msg);
        },
      );
    } catch (e) {
      LogUtil.e(message:e.toString());
    }
  }

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

  Future<bool> asyncUserAccount() async{
    bool status = false;
    CommonUtils.showLoading();
    await DioClient.instance.requestNetwork<Map>(url: ApiConstants.syncAccount,onSuccess: (result){
      if(result!=null){
        LogUtil.d(message: "async account:${result}");
        var key = result["key"];
        if(key!=null) {
          CommonUtils.hideLoading();
          restartApp(key);
        }
      }
    },onError: (code,message,data){
      // SharedPreferenceUtil.instance.setValue(key: SharedPresKeys.isOpenToMain, value: false);
      CommonUtils.hideLoading();
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


  viewProfile({required String userId}){
    Map<String,String> params = {};
    params.putIfAbsent(ConstantData.paramsUserId, () => userId);
    //Get.toNamed(WfRoutes.userProfile,parameters: params);
  }

  Future<void> updateStoredUserData(Map<String, dynamic> updates) async {
    String? storedUserJson = await SharedPreferenceUtil.instance.getValue(key: SharedPresKeys.selfEntity);
    if (storedUserJson != null) {
      Map<String, dynamic> storedUserMap = json.decode(storedUserJson);
      storedUserMap.addAll(updates);
      String updatedUserJson = json.encode(storedUserMap);
      await SharedPreferenceUtil.instance.setValue(key: SharedPresKeys.selfEntity, value: updatedUserJson);
      selfUser = UserDataEntity.fromJson(storedUserMap);
      rxSelfUser.value = selfUser;
    }
  }


}