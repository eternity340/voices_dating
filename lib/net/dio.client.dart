import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:voices_dating/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getX;
import '../components/custom_content_dialog.dart';
import '../constants/constant_data.dart';
import '../entity/base_entity.dart';
import '../utils/common_utils.dart';
import '../utils/log_util.dart';
import 'error_handler.dart';

const connectionTimeout = 30000;
const receiveTimeout = 30000;
const sendTimeout = 30000;

typedef NetSuccessCallback<T> = Function(T? data);
typedef NetSuccessListCallback<T> = Function(List<T> data);
typedef NetErrorCallback<T> = Function(int code, String msg,T? data);

class DioClient{

  static  final DioClient _instance = DioClient._() ;

  factory DioClient() => _instance;

  late CancelToken cancelToken;

  bool _isNetworkErrorDialogShowing = false;


  DioClient._(){
    _dio = Dio();
  }

  init({BaseOptions? options, List<Interceptor>? interceptors}){
    if(options!=null) {
      _dio.options = options;
    }

    if(interceptors!=null) {
      _dio.interceptors.addAll(interceptors);
    }
    cancelToken = CancelToken();
    LogUtil.d(message: "optionurl:${options?.baseUrl??""}");
  }

  void addInterceptor(Interceptor interceptor){
    _dio.interceptors.add(interceptor);
  }

  static DioClient get instance => DioClient();

  static late Dio _dio;

  Dio get dio => _dio;

  Future<BaseEntity<T>> _request<T>(
      String method,
      String url, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
        Options? options,
      }) async {
    final Response<String> response = await _dio.request<String>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: _validateOptions(method, options),
      cancelToken: cancelToken??this.cancelToken,
    );
    try {
      final String data = response.data.toString();
      final Map<String, dynamic> _map = parseData(data);
      return BaseEntity<T>.fromJson(_map);
    } catch (e) {
      LogUtil.e(message: 'parse error:${e}');
      return BaseEntity<T>(
          code: ExceptionHandler.parse_error,
          data: null,
          msg: 'Data parsing error');
    }
  }

  Future put<T>(
      { Method method = Method.put,
        required String url,
        NetSuccessCallback<T>? onSuccess,
        NetErrorCallback<T>? onError,
        dynamic params,
        CancelToken? cancelToken,
        Options? options,
        bool formParams = false,
      }) {

    return _request<T>(
      method.value,
      url,
      data: params,
      options: options,
      cancelToken: cancelToken,
    ).then<void>(
          (BaseEntity<T> result) {
        if (ConstantData.successResponseCode.contains(result.code) ) {
          if (onSuccess != null) {
            onSuccess(result.data);
          }
        } else {
          _onError<T>(result.code, result.msg, onError, result.data,
              requestUrl: url);
        }
      },
      onError: (dynamic e) {
        _cancelLogPrint(e, url);
        final NetError? error = ExceptionHandler.handleException(e);
        if (error != null) {
          _onError<T>(error.code, error.msg, onError, null);
        }
      },
    );
  }


  Future requestNetwork<T>({
    Method method = Method.post,
    required String url,
    NetSuccessCallback<T>? onSuccess,
    NetErrorCallback<T>? onError,
    dynamic params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    bool formParams = false,
  }) async {
    var _params = params ?? <String, String>{};
    FormData formData = formParams ? params : FormData.fromMap(_params);

    try {
      final BaseEntity<T> result = await _request<T>(
        method.value,
        url,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      if (ConstantData.successResponseCode.contains(result.code)) {
        if (onSuccess != null) {
          onSuccess(result.data);
        }
      } else {
        _onError<T>(result.code, result.msg, onError, result.data, requestUrl: url);
      }
    } catch (e) {
      _cancelLogPrint(e, url);
      final NetError error = ExceptionHandler.handleException(e);
      if (error.code == ExceptionHandler.net_error || error.code == ExceptionHandler.socket_error) {
        if (!_isNetworkErrorDialogShowing) {
          _showNetworkErrorDialog(() {
            // 重试请求
            requestNetwork(
              method: method,
              url: url,
              onSuccess: onSuccess,
              onError: onError,
              params: params,
              queryParameters: queryParameters,
              cancelToken: cancelToken,
              options: options,
              formParams: formParams,
            );
          });
        }
      } else {
        _onError<T>(error.code, error.msg, onError, null, requestUrl: url);
      }
    }
  }

  void _showNetworkErrorDialog(VoidCallback onRetry) {
    if (_isNetworkErrorDialogShowing) return;

    _isNetworkErrorDialogShowing = true;
    getX.Get.dialog(
      CustomContentDialog(
        title: 'Network Error',
        content: 'Failed to connect to the server. Please check your internet connection and try again.',
        buttonText: 'Retry',
        onButtonPressed: () {
          getX.Get.back(); // 关闭对话框
          _isNetworkErrorDialogShowing = false; // 重置标志
          onRetry(); // 执行重试操作
        },
      ),
      barrierDismissible: false,
    ).then((_) {
      _isNetworkErrorDialogShowing = false; // 确保对话框关闭时重置标志
    });
  }

  void asyncRequestNetwork<T>(
      Method method,
      String url, {
        NetSuccessCallback<T>? onSuccess,
        NetErrorCallback<T>? onError,
        dynamic params,
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
        Options? options,
      }) {
    Stream.fromFuture(
      _request<T>(
        method.value,
        url,
        data: params,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    ).asBroadcastStream().listen(
          (result) {
        if (result.code == 200) {
          if (onSuccess != null) {
            onSuccess(result.data!);
          }
        } else {
          _onError<T>(result.code, result.msg, onError, result.data,
              requestUrl: url);
        }
      },
      onError: (dynamic e) {
        _cancelLogPrint(e, url);
        final NetError? error = ExceptionHandler.handleException(e);
        if (error != null) {
          _onError<T>(error.code, error.msg, onError, null, requestUrl: url);
        }
      },
    );
  }

  Options _validateOptions(String method, Options? options) {
    options ??= Options();
    options.method = method;
    return options;
  }


  void _cancelLogPrint(dynamic e, String url) {
    if (e is DioError && CancelToken.isCancel(e)) {}
  }

  void _onError<T>(int code, String msg, NetErrorCallback<T>? onError, T? data,
      {String? requestUrl}) {
    if (onError != null) {
      onError(code, msg, data);
    }else{
      if(!msg.isNullOrEmpty){
        CommonUtils.hideLoading();
        if(code!=ExceptionHandler.unknown_error) {
          CommonUtils.showSnackBar(msg);
        }
      }
    }
  }

  Map<String, dynamic> parseData(String data) {
    return json.decode(data) as Map<String, dynamic>;
  }

  cancelAllRequest(){
    cancelToken.cancel();
    cancelToken.whenCancel.then((value) => cancelToken = CancelToken());
  }

}

enum Method { get, post, put, patch, delete, head }

extension MethodExtension on Method {
  String get value => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'][index];
}