import 'dart:convert';
import 'package:dio/dio.dart';
import '../../constants/constant_data.dart';
import '../../service/app_service.dart';
import '../../service/token_service.dart';
import 'package:get/get.dart' as get_lib;
import '../../utils/common_utils.dart';
import '../../utils/device_utils.dart';
import '../../utils/log_util.dart';
import '../../utils/shared_preference_util.dart';
import '../api_constants.dart';
import '../../utils/string_extension.dart';

class RequestInterceptor extends QueuedInterceptorsWrapper{


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final TokenService tokenService = get_lib.Get.find<TokenService>();
    tokenService.getTokenEntity().then((tokenEntity) async{
      Map<String,dynamic> headerMap = await buildRequestHeader();
      options.headers.addAll(headerMap);
      options.headers.update("Token", (value) => tokenEntity.accessToken,ifAbsent: ()=>tokenEntity.accessToken);
      handler.next(options);
    });

    // super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handleResponse(response).then((result) {
      handler.next(result);
    });
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if(err.response==null){
      handler.next(err);
    }else {
      handleResponse(err.response!).then((result) {
        handler.next(err);
      });
    }
  }

  Future<Response> handleResponse(Response response) async {
    bool isLogin = SharedPreferenceUtil().getValue(key: SharedPresKeys.isLogin) ?? false;
    if (ConstantData.successResponseCode.contains(response.statusCode)) {
      Map<String, dynamic> jsonData = json.decode(response.data);
      LogUtil.d(message: "Original Response data: ${response.data}");

      decodeDataIfNeeded(jsonData);

      int resultCode = jsonData["code"];
      LogUtil.d(message: "result:code-$resultCode");

      if (isSpecialResultCode(resultCode)) {
        return await handleSpecialResultCode(resultCode, isLogin, response);
      }

      response.data = json.encode(jsonData);
    } else if (response.statusCode == 403 || response.statusCode == 400) {
      handleAuthError(isLogin);
    }
    return response;
  }

  void decodeDataIfNeeded(Map<String, dynamic> jsonData) {
    if (jsonData.containsKey("data") && jsonData["data"] is String && jsonData["data"].isNotEmpty) {
      try {
        String decodedData = utf8.decode(base64.decode(jsonData["data"]));
        jsonData["data"] = json.decode(decodedData);
        LogUtil.d(message: "Decoded data: ${jsonData["data"]}");
      } catch (e) {
        LogUtil.e(message: "Error decoding data: $e");
      }
    } else {
      LogUtil.d(message: "Data is empty or not a string, skipping decoding");
    }
  }

  bool isSpecialResultCode(int resultCode) {
    return resultCode == 10001001 || resultCode == 2000110 || resultCode == 2000116;
  }

  Future<Response> handleSpecialResultCode(int resultCode, bool isLogin, Response response) async {
    if (resultCode == 2000116) {
      if (isLogin) {
        get_lib.Get.find<AppService>().forceLogout();
      } else {
        get_lib.Get.find<TokenService>().clearToken();
      }
    } else {
      get_lib.Get.find<TokenService>().clearToken();
      await get_lib.Get.find<TokenService>().refreshToken();
      return await getNewResponse(response);
    }
    return response;
  }

  void handleAuthError(bool isLogin) {
    if (isLogin) {
      get_lib.Get.find<AppService>().forceLogout();
    } else {
      get_lib.Get.find<TokenService>().clearToken();
    }
  }



//
  Future getNewResponse(Response preResponse) async{
    Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstants.getBaseUrl(),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: Headers.formUrlEncodedContentType,
      responseType: ResponseType.json,
    ));
    Response response;
    String  newPath = preResponse.realUri.toString();
    Map<String,dynamic> headerMap = await buildRequestHeader();
    dio.options.headers = headerMap;
    String? token = await get_lib.Get.find<TokenService>().getToken();
    LogUtil.d(message: "new request:$newPath");

    if(token!=null) {
      dio.options.headers.update("Token", (value) => token,ifAbsent: ()=>token);
    }

    if(preResponse.requestOptions.method=="GET"){
      response = await dio.get(newPath,
          queryParameters: preResponse.data, options: null, cancelToken: null).catchError((
          error) {});
    }else {
      response = await dio.post(newPath,
          data: preResponse.data, options: null, cancelToken: null).catchError((
          error) {});
    }
    return response;
  }

  Future<Map<String,dynamic>> buildRequestHeader() async{
    Map<String,dynamic> headerMap = {};

    String? deviceToken =  SharedPreferenceUtil().getValue(key: SharedPresKeys.fireToken);
    if(!deviceToken.isNullOrEmpty) {
      headerMap.putIfAbsent("devicetoken", () => deviceToken);
    }

    int currentTimeStamp = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    String nonce = CommonUtils.randomBit(4);
    String signature = CommonUtils.getSigngure(appId: ApiConstants.appId,appSecret: ApiConstants.appSecret,time: currentTimeStamp, nonce:nonce);
    String clientVersion = await DeviceUtils.getVersion();
    String uuid = await DeviceUtils.getUUID();
    headerMap.putIfAbsent("clientversion", () =>clientVersion);
    headerMap.putIfAbsent("Signature", () =>signature);
    headerMap.putIfAbsent("Timestamp", () =>currentTimeStamp);
    headerMap.putIfAbsent("Nonce", () =>nonce);
    headerMap.putIfAbsent("UUID", () =>uuid);

    // if(Platform.isAndroid){
    //   headerMap.putIfAbsent("devicetype", () => "2");
    // }else{
    headerMap.putIfAbsent("devicetype", () => "1");
    // }
    return headerMap;

  }

}