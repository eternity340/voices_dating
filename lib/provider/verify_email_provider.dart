import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../service/token_service.dart';
import '../model/verify_email_model.dart';
import '../verify_success.dart';

class VerifyEmailProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  bool _isLoading = false;
  String? _errorMessage;
  String? _accessToken;
  VerifyEmailModel? _verifyEmailModel;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void initialize(VerifyEmailModel model) {
    _verifyEmailModel = model;
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    Map<String, String>? tokenData = await getToken();
    if (tokenData != null) {
      _accessToken = tokenData['access_token'];
      print('Token initialized: $_accessToken');
    } else {
      _errorMessage = "无法获取访问令牌。";
      print('Failed to initialize token');
    }
    notifyListeners();
  }

  Future<void> verifyEmail(String code) async {
    if (_accessToken == null) {
      _errorMessage = "没有可用的访问令牌。";
      print('No access token available');
      notifyListeners();
      return;
    }

    final String email = _verifyEmailModel!.email;
    final String verificationKey = _verifyEmailModel!.verificationKey;

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
        // Assuming VerifySuccessPage is a separate page
        // You may need to handle navigation here differently
        Get.to(() => VerifySuccessPage(message: response.data['message']));
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
