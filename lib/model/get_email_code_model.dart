import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../verify_email.dart'; // 导入验证码页面
import '../service/token_service.dart'; // 导入 token_service.dart

class GetEmailCodeModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final Dio _dio = Dio();
  bool _isLoading = false;
  String? _errorMessage;
  String? _accessToken;

  GetEmailCodeModel() {
    _initializeToken();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _initializeToken() async {
    Map<String, String>? tokenData = await getToken();
    if (tokenData != null) {
      _accessToken = tokenData['access_token'];
      print('Token initialized: $_accessToken');
    } else {
      _errorMessage = "无法获取访问令牌。";
      print('Failed to initialize token');
      notifyListeners();
    }
  }

  Future<void> sendVerificationCode() async {
    if (_accessToken == null) {
      _errorMessage = "没有可用的访问令牌。";
      print('No access token available');
      notifyListeners();
      return;
    }

    final String email = emailController.text.trim();

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.get(
        'https://api.masonvips.com/v1/email_verification_code',
        queryParameters: {'email': email},
        options: Options(headers: {'token': _accessToken}),
      );

      if (response.statusCode == 200) {
        final verificationKey = response.data['data']['key']; // 重命名 key 为 verificationKey
        Get.to(() => VerifyEmailPage(email: email, verificationKey: verificationKey)); // 传递 verificationKey
      } else {
        _errorMessage = "错误: ${response.statusMessage}";
        print('Error: ${response.statusMessage}');
      }
    } catch (e) {
      _errorMessage = "异常: $e";
      print('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
