import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../page/verify_success_page.dart';
import '../../service/token_service.dart';

class VerifyEmailModel extends ChangeNotifier {
  final String email;
  final String verificationKey;
  final TextEditingController codeController = TextEditingController();
  final Dio _dio = Dio();
  bool _isLoading = false;
  String? _errorMessage;
  String? _accessToken;

  VerifyEmailModel({required this.email, required this.verificationKey}) {
    _initializeToken();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _initializeToken() async {
    Map<String, String>? tokenData = await getToken();
    if (tokenData != null) {
      _accessToken = tokenData['access_token'];
      notifyListeners();
    } else {
      _errorMessage = "无法获取访问令牌。";
      notifyListeners();
    }
  }

  Future<void> verifyEmail() async {
    if (_accessToken == null) {
      _errorMessage = "没有可用的访问令牌。";
      notifyListeners();
      return;
    }

    final String code = codeController.text.trim();

    if (verificationKey.isEmpty) {
      _errorMessage = "验证密钥为空。";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.post(
        'https://api.masonvips.com/v1/verify_email',
        queryParameters: {
          'email': email,
          'code': code,
          'key': verificationKey,
        },
        options: Options(headers: {'token': _accessToken}),
      );

      if (response.data['code'] == 200 && response.data['data']['ret'] == true) {
        Get.toNamed('/verify_success', arguments: {
          'message': response.data['message'],
        });
      } else {
        _errorMessage = "验证失败: ${response.data['message']}";
      }
    } catch (e) {
      _errorMessage = "发生异常: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
