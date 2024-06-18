import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;

import '../../service/token_service.dart';  // 确保这个路径是正确的

class SignInModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Dio _dio = Dio();
  bool _isLoading = false;
  String? _emailErrorMessage;
  String? _passwordErrorMessage;
  String? _errorMessage;
  String? _accessToken;

  SignInModel() {
    _initializeToken();
  }

  bool get isLoading => _isLoading;
  String? get emailErrorMessage => _emailErrorMessage;
  String? get passwordErrorMessage => _passwordErrorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> _initializeToken() async {
    await initializeToken(
      onSuccess: (token) {
        _accessToken = token;
        notifyListeners();
      },
      onError: (errorMessage) {
        _errorMessage = errorMessage;
        notifyListeners();
      },
    );
  }

  Future<void> signIn() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty) {
      _emailErrorMessage = "电子邮件不能为空";
      notifyListeners();
      return;
    } else {
      _emailErrorMessage = null;
    }

    if (password.isEmpty) {
      _passwordErrorMessage = "密码不能为空";
      notifyListeners();
      return;
    } else {
      _passwordErrorMessage = null;
    }

    if (_accessToken == null) {
      _errorMessage = "没有可用的访问令牌。";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
      });

      final response = await _dio.post(
        'https://api.masonvips.com/v1/signin',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'token': _accessToken,
          },
        ),
      );
      if (response.data['code'] == 200) {
        getx.Get.toNamed('/get_mail_code');
      } else {
        _errorMessage = "错误: ${response.data['message']}";
      }
    } catch (e) {
      _errorMessage = "异常: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
