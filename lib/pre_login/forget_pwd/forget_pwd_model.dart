import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../service/token_service.dart';

class ForgetPwdModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final dio.Dio _dio = dio.Dio();
  bool _isLoading = false;
  String? _errorMessage;
  String? _accessToken;

  ForgetPwdModel() {
    _initializeToken();
  }

  bool get isLoading => _isLoading;
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

  Future<void> sendResetEmail() async {
    if (_accessToken == null) {
      _errorMessage = "无可用的访问令牌。";
      notifyListeners();
      return;
    }

    final String email = emailController.text.trim();

    if (email.isEmpty) {
      _errorMessage = "邮箱不能为空。";
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
        options: dio.Options(headers: {'token': _accessToken}),
      );

      if (response.data['code'] == 200) {
        final bool ret = response.data['data']['ret'];
        if (ret) {
          _showDialog("成功", "重置邮件发送成功");
        } else {
          _errorMessage = "发送重置邮件失败";
        }
      } else {
        final errCode = response.data['errCode'];
        final errMsg = response.data['errMsg'];
        _errorMessage = "错误 $errCode: $errMsg";
      }
    } catch (e) {
      _errorMessage = "异常: $e";
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
              child: const Text("确定"),
            ),
          ],
        );
      },
    );
  }
}
