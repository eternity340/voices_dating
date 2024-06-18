import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'dart:math';

Future<Map<String, String>?> getToken() async {
  String appId = 'fed327531298e7f863cdf2c2ad0903e9';
  String appSecret = '0013ce26-7219-b304-1d18-072c46c0aab2';
  int currentTimeStamp = (DateTime.now().millisecondsSinceEpoch / 1000).round();
  String nonce = generateNonce(4);
  String signKey = generateMD5('$currentTimeStamp$appId$appSecret$nonce');

  // 创建请求头
  Map<String, dynamic> tokenHeader = {
    'AppId': appId,
    'Signature': signKey,
    'Nonce': nonce,
    'Timestamp': currentTimeStamp,
  };

  Dio dio = Dio();

  int retryCount = 0;
  int maxRetries = 3;

  while (retryCount < maxRetries) {
    try {
      Response response = await dio.post(
        'https://api.masonvips.com/v1/access_token',
        options: Options(
          headers: tokenHeader,
        ),
      );

      if (response.statusCode == 200) {
        print('Token received: ${response.data['access_token']}');
        return {
          'access_token': response.data['access_token'],
          'Signature': signKey,
        }; // 返回包含 access_token 和 Signature 的 Map
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

String generateNonce(int length) {
  const chars = '0123456789';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

String generateMD5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}