import 'dart:io';
import 'package:dio/dio.dart';

class ExceptionHandler {
  static const int success = 200;
  static const int success_not_content = 204;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int not_found = 404;

  static const int net_error = 1000;
  static const int parse_error = 1001;
  static const int socket_error = 1002;
  static const int http_error = 1003;
  static const int connect_timeout_error = 1004;
  static const int send_timeout_error = 1005;
  static const int receive_timeout_error = 1006;
  static const int cancel_error = 1007;
  static const int unknown_error = 9999;

  static final Map<int, NetError> _errorMap = <int, NetError>{
    net_error: NetError(net_error, 'Network anomaly, please check your network'),
    parse_error: NetError(parse_error, 'Data parsing error'),
    socket_error: NetError(socket_error, 'Network anomaly, please check your network'),
    http_error: NetError(http_error, 'Server exception, please try again later！'),
    connect_timeout_error: NetError(connect_timeout_error, 'Connection timeout'),
    send_timeout_error: NetError(send_timeout_error, 'Request Timeout'),
    receive_timeout_error: NetError(receive_timeout_error, 'Response timeout'),
    cancel_error: NetError(cancel_error, 'Cancel Request'),
    unknown_error: NetError(unknown_error, 'Unknown anomalies'),
  };

  static NetError handleException(dynamic error) {
    print(error);
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return _errorMap[connect_timeout_error]!;
        case DioExceptionType.sendTimeout:
          return _errorMap[send_timeout_error]!;
        case DioExceptionType.receiveTimeout:
          return _errorMap[receive_timeout_error]!;
        case DioExceptionType.badResponse:
          return _errorMap[http_error]!;
        case DioExceptionType.cancel:
          return _errorMap[cancel_error]!;
        case DioExceptionType.connectionError:
          return _errorMap[net_error]!;
        case DioExceptionType.unknown:
        default:
          return _handleException(error.error);
      }
    } else {
      return _handleException(error);
    }
  }

  static NetError _handleException(dynamic error) {
    if (error is SocketException) {
      return _errorMap[socket_error]!;
    }
    if (error is HttpException) {
      return _errorMap[http_error]!;
    }
    if (error is FormatException) {
      return _errorMap[parse_error]!;
    }
    return _errorMap[unknown_error]!;
  }
}

class NetError {
  NetError(this.code, this.msg);

  int code;
  String msg;
}
