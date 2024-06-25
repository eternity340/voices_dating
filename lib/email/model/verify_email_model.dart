import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../service/token_service.dart';
import '../../entity/User.dart';
import '../../net/error_handler.dart';  // 确保导入错误处理模块

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
      _errorMessage = "Unable to obtain access token.";
      notifyListeners();
    }
  }

  Future<void> verifyEmail() async {
    if (_accessToken == null) {
      _errorMessage = "No access token available.";
      notifyListeners();
      _showErrorDialog(_errorMessage!);
      return;
    }

    final String code = codeController.text.trim();

    if (verificationKey.isEmpty) {
      _errorMessage = "Verification key is empty.";
      notifyListeners();
      _showErrorDialog(_errorMessage!);
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
        User user = User(email: email);
        Get.toNamed('/verify_success', arguments: {
          'message': response.data['message'],
          'user': user,
        });
      } else {
        _errorMessage = "Verification failed: ${response.data['message']}";
        _showErrorDialog(_errorMessage!);
      }
    } catch (e) {
      final netError = ExceptionHandler.handleException(e);
      _errorMessage = netError?.msg ?? "Unexpected exception occurred.";
      _showErrorDialog(_errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
