import 'dart:convert';
import 'package:dio/dio.dart';
import '../../utils/log_util.dart';

class DioLogInterceptor extends InterceptorsWrapper{
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LogUtil.d(message: "-----request-----");
    LogUtil.d(message:"url = ${options.uri.toString()}",);
    LogUtil.d(message:"headers = ${options.headers}", );
    LogUtil.d(message:"queryparams = ${options.queryParameters}", );
    if(options.data is FormData){
      LogUtil.d(message:"data = ${(options.data as FormData).fields}");
    }else {
      LogUtil.d(message:"data = ${options.data.toString()}",);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LogUtil.d(message: "\n----- response -----",
    );
    LogUtil.d(message: "url = ${response.realUri.toString()}");
    LogUtil.d(message: "code = ${response.statusCode}");
    LogUtil.d(message: "data = ${json.encoder.convert(response.data)}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LogUtil.e(message: "\n------Error -----",
    );
    LogUtil.e(message: "url = ${err.requestOptions.uri.toString()}");
    LogUtil.e(message:"type = ${err.type}");
    LogUtil.e(message:"error = ${err.error}");
    LogUtil.e(message:"message = ${err.message}");
    LogUtil.e(message:"message = ${err.response?.data?.toString()}");
    LogUtil.e(message:"code = ${err.response?.statusCode}");
    LogUtil.e(message: "\n");
    super.onError(err, handler);
  }


}