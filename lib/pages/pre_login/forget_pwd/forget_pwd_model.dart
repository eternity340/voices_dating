import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../service/token_service.dart';
import '../../../entity/token_entity.dart'; // 导入 TokenEntity 类

class ForgetPwdModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final dio.Dio _dio = dio.Dio();
  bool _isLoading = false;
  String? _errorMessage;
  TokenEntity? _tokenEntity; // 使用 TokenEntity 替代 _accessToken

  ForgetPwdModel() {
    _initializeToken();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _initializeToken() async {
    await initializeToken(
      onSuccess: (tokenEntity) {
        _tokenEntity = tokenEntity;
        notifyListeners();
      },
      onError: (errorMessage) {
        _errorMessage = errorMessage;
        notifyListeners();
      },
    );
  }

  Future<void> sendResetEmail() async {
    if (_tokenEntity == null || _tokenEntity?.accessToken == null) {
      _errorMessage = "No access token available";
      notifyListeners();
      return;
    }

    final String email = emailController.text.trim();

    if (email.isEmpty) {
      _errorMessage = "email can not be empty";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final formData = dio.FormData.fromMap({
        'email': email,
      });

      final response = await _dio.post(
        'https://api.masonvips.com/v1/forget_password',
        data: formData,
        options: dio.Options(headers: {'token': _tokenEntity!.accessToken}),
      );

      if (response.data['code'] == 200) {
        final bool ret = response.data['data']['ret'];
        if (ret) {
          _showDialog("success", "Reset email sent successfully");
        } else {
          _errorMessage = "Failed to send reset email";
        }
      } else {
        final errCode = response.data['errCode'];
        final errMsg = response.data['errMsg'];
        _errorMessage = "error $errCode: $errMsg";
      }
    } catch (e) {
      _errorMessage = "exception: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}
