import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../constants/constant_data.dart';
import '../entity/token_entity.dart';
import '../net/api_constants.dart';
import '../utils/common_utils.dart';
import '../utils/log_util.dart';
import '../utils/shared_preference_util.dart';
import 'app_service.dart';

class TokenService extends GetxService{

  static TokenService get instance => Get.find<TokenService>();

  TokenEntity? tokenEntity;


  @override
  void onInit(){
    super.onInit();
  }


  Future<TokenService> init() async{
    return this;
  }

  Future<TokenEntity> getTokenEntity() async{
    if(tokenEntity==null){
      String? tokenStr = SharedPreferenceUtil().getValue(key: SharedPresKeys.userToken);
      bool containToken = tokenStr!=null;
      if(!containToken) {
        tokenEntity =  await refreshToken();
      }else{
        tokenEntity = TokenEntity.fromJson(json.decode(tokenStr));
        if(tokenExpired()){
          tokenEntity =  await refreshToken(isRefresh:true);
        }
      }
    }
    return tokenEntity!;
  }



  refreshToken({bool isRefresh = false}) async{
    Map<String,dynamic> tokenHeader = {};
    String signKey = "";

    Map<String,dynamic> refreshData = {};
    int currentTimeStamp = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    String nonce = CommonUtils.randomBit(4);
    signKey = CommonUtils.getSignKey(appId: ApiConstants.appId,appSecret: ApiConstants.appSecret,time: currentTimeStamp, nonce:nonce);
    tokenHeader.putIfAbsent("AppId", () => ApiConstants.appId);
    tokenHeader.putIfAbsent("Signature", () => signKey);
    tokenHeader.putIfAbsent("Nonce", () => nonce);
    tokenHeader.putIfAbsent("Timestamp", () => currentTimeStamp);

    if(isRefresh&&tokenEntity!=null){
      refreshData = buildRefreshTokenData(tokenEntity!.refreshToken!);
    }


    BaseOptions tokenOptions = BaseOptions(
      baseUrl: ApiConstants.getBaseUrl(),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: tokenHeader,
      contentType: Headers.formUrlEncodedContentType,
      responseType: ResponseType.plain,
    );

    Dio tokenDio =  Dio(tokenOptions);

    String tokenUrl = ApiConstants.accessToken;

    try{
      Response response = await tokenDio.post(tokenUrl,data: refreshData);
      bool isLogin = SharedPreferenceUtil().getValue(key: SharedPresKeys.isLogin)??false;
      if(response.statusCode==200){
        Map<String,dynamic> jsonData = json.decode(response.data.toString());
        if(jsonData!=null){
          LogUtil.v(message: "token:$jsonData");
          tokenEntity = TokenEntity.fromJson(jsonData);
          tokenEntity!.requestTime = currentTimeStamp;
          SharedPreferenceUtil().setValue(key: SharedPresKeys.userToken, value: json.encode(tokenEntity));
        }else{
          if(isLogin) {
            Get.find<AppService>().forceLogout();
          }
        }
      }else{
        if(!isLogin) {
          clearToken();
        }else {
          Get.find<AppService>().forceLogout();
        }
      }
    }on DioError catch (e) {
      Get.find<AppService>().forceLogout();
    }
    return tokenEntity;
  }

  buildRefreshTokenData(String currentToken){
    Map<String, dynamic> requestMap =  {};
    requestMap.putIfAbsent("grant_type", () => "refresh_token");
    requestMap.putIfAbsent("refresh_token", () => currentToken);
    return requestMap;
  }

  updateToken({required String newToken}){
    tokenEntity!.accessToken = newToken;
    SharedPreferenceUtil().setValue(key: SharedPresKeys.userToken, value: json.encode(tokenEntity));

  }

  bool tokenExpired(){
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int endTime =
        tokenEntity!.expiredIn! + tokenEntity!.requestTime! - 3600;
    LogUtil.d(message: "expire:${tokenEntity!.expiredIn}--request:${tokenEntity!.requestTime}--current:$currentTime,end:$endTime");
    return currentTime > endTime;
  }

  String? getToken(){
    if(tokenEntity!=null) {
      return tokenEntity!.accessToken;
    } else {
      return null;
    }
  }

  clearToken(){
    tokenEntity = null;
    SharedPreferenceUtil().setValue(key: SharedPresKeys.userToken, value: null);
  }


}