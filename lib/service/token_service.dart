import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'dart:math';
import '../entity/token_entity.dart';

class TokenService {
  static const String _appId = 'fed327531298e7f863cdf2c2ad0903e9';
  static const String _appSecret = '0013ce26-7219-b304-1d18-072c46c0aab2';

  Dio _dio = Dio();

  Future<TokenEntity?> getToken() async {
    int currentTimeStamp = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    String nonce = _generateNonce(4);
    String signKey = _generateMD5('$currentTimeStamp$_appId$_appSecret$nonce');

    // 创建请求头
    Map<String, dynamic> tokenHeader = {
      'AppId': _appId,
      'Signature': signKey,
      'Nonce': nonce,
      'Timestamp': currentTimeStamp,
    };

    int retryCount = 0;
    int maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        Response response = await _dio.post(
          'https://api.masonvips.com/v1/access_token',
          options: Options(
            headers: tokenHeader,
          ),
        );

        if (response.statusCode == 200) {
          print('Token received: ${response.data['access_token']}');
          return TokenEntity.fromJson(response.data); // 返回 TokenEntity 实例
        } else {
          print('Failed to get token: ${response.statusCode}, ${response.data}');
          return null;
        }
      } catch (e) {
        print('Error: $e');
        retryCount++;
        if (retryCount < maxRetries) {
          print('Retrying to get token... attempt $retryCount');
          await Future.delayed(Duration(seconds: 2));
        } else {
          print('Failed to get token after $retryCount attempts');
          return null;
        }
      }
    }
    return null;
  }

  String _generateNonce(int length) {
    const chars = '0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  String _generateMD5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}

Future<void> initializeToken({
  required Function(TokenEntity) onSuccess,
  required Function(String) onError,
}) async {
  TokenService tokenService = TokenService();
  TokenEntity? tokenEntity = await tokenService.getToken();
  if (tokenEntity != null) {
    onSuccess(tokenEntity);
  } else {
    onError("Unable to obtain access token.");
  }
}
