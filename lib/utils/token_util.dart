import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'dart:math';

class TokenGenerator {
  late String appId;
  late String appSecret;
  late String apiUrl;
  final int maxRetries;

  Map<String, String>? _cachedToken;
  DateTime? _tokenExpirationTime;

  final Map<String, Map<String, String>> configurations = {
    'default': {
      'appId': 'fed327531298e7f863cdf2c2ad0903e9',
      'appSecret': '0013ce26-7219-b304-1d18-072c46c0aab2',
      'apiUrl': 'https://api.masonvips.com/v1/access_token',
    },
    'voicesDating': {
      'appId': '699010ebcf61c7d459bcce7aa789efc6',
      'appSecret': '4568eea9-dd84-31b5-0a04-45efad009df2',
      'apiUrl': 'https://api.voicesdating.com/access_token',
    },
  };

  TokenGenerator({String configKey = 'default', this.maxRetries = 3}) {
    _setConfiguration(configKey);
  }

  void _setConfiguration(String key) {
    if (configurations.containsKey(key)) {
      appId = configurations[key]!['appId']!;
      appSecret = configurations[key]!['appSecret']!;
      apiUrl = configurations[key]!['apiUrl']!;
      _cachedToken = null;
      _tokenExpirationTime = null;
    } else {
      throw ArgumentError('Invalid configuration key: $key');
    }
  }

  void switchConfiguration(String key) {
    _setConfiguration(key);
  }

  Future<Map<String, String>?> getToken() async {
    if (_cachedToken != null && _tokenExpirationTime != null && DateTime.now().isBefore(_tokenExpirationTime!)) {
      print('Using cached token');
      return _cachedToken;
    }

    int currentTimeStamp = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    String nonce = _generateNonce(4);
    String signKey = _generateMD5('$currentTimeStamp$appId$appSecret$nonce');

    Map<String, dynamic> tokenHeader = {
      'AppId': appId,
      'Signature': signKey,
      'Nonce': nonce,
      'Timestamp': currentTimeStamp,
    };

    Dio dio = Dio();
    dio.options.followRedirects = true;
    dio.options.maxRedirects = 5;
    dio.options.validateStatus = (status) {
      return status! < 500;
    };

    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        Response response = await dio.post(
          apiUrl,
          options: Options(
            headers: tokenHeader,
            followRedirects: true,
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        );

        if (response.statusCode == 200) {
          print('New token received: ${response.data['access_token']}');
          _cachedToken = {
            'access_token': response.data['access_token'],
            'Signature': signKey,
          };
          _tokenExpirationTime = DateTime.now().add(Duration(hours: 1));
          return _cachedToken;
        } else if (response.statusCode == 302) {
          String? redirectUrl = response.headers.value('location');
          if (redirectUrl != null) {
            print('Redirecting to: $redirectUrl');
            response = await dio.post(
              redirectUrl,
              options: Options(
                headers: tokenHeader,
                followRedirects: true,
                validateStatus: (status) {
                  return status! < 500;
                },
              ),
            );
            if (response.statusCode == 200) {
              print('New token received after redirection: ${response.data['access_token']}');
              _cachedToken = {
                'access_token': response.data['access_token'],
                'Signature': signKey,
              };
              _tokenExpirationTime = DateTime.now().add(Duration(hours: 1));
              return _cachedToken;
            }
          }
        }
        print('Failed to get token: ${response.statusCode}, ${response.data}');
        return null;
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

  Future<void> initializeToken({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    Map<String, String>? tokenData = await getToken();
    if (tokenData != null) {
      onSuccess(tokenData['access_token']!);
      print('Token initialized: ${tokenData['access_token']}');
    } else {
      onError("无法获取访问令牌。");
      print('Failed to initialize token');
    }
  }
}

void main() async {
  TokenGenerator tokenGenerator = TokenGenerator();

  // 使用默认配置获取 token
  await tokenGenerator.initializeToken(
    onSuccess: (token) {
      print('Successfully obtained token for default config: $token');
    },
    onError: (error) {
      print('Error obtaining token for default config: $error');
    },
  );

  // 再次调用，应该使用缓存的 token
  await tokenGenerator.initializeToken(
    onSuccess: (token) {
      print('Using cached token for default config: $token');
    },
    onError: (error) {
      print('Error obtaining token for default config: $error');
    },
  );

  // 切换到 VoicesDating 配置
  tokenGenerator.switchConfiguration('voicesDating');

  // 使用 VoicesDating 配置获取新的 token
  await tokenGenerator.initializeToken(
    onSuccess: (token) {
      print('Successfully obtained token for VoicesDating: $token');
    },
    onError: (error) {
      print('Error obtaining token for VoicesDating: $error');
    },
  );

  // 再次调用 VoicesDating 配置，应该使用缓存的 token
  await tokenGenerator.initializeToken(
    onSuccess: (token) {
      print('Using cached token for VoicesDating: $token');
    },
    onError: (error) {
      print('Error obtaining token for VoicesDating: $error');
    },
  );
}
