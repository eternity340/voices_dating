import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import '../../entity/token_entity.dart';

class DioInterceptor extends Interceptor {
  final TokenEntity tokenEntity;

  DioInterceptor(this.tokenEntity);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add common headers
    options.headers['token'] = tokenEntity.accessToken;

    // You can add other common request handling logic here
    print('REQUEST[${options.method}] => PATH: ${options.path}');

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle response
    if (response.data['code'] == 200) {
      // You can add common success response handling logic here
      print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    }

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // Handle error
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');

    // You can handle the error globally here, e.g., show error messages
    getX.Get.snackbar('Error', err.message ?? 'An error occurred');

    return super.onError(err, handler);
  }
}