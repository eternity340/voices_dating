import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../entity/User.dart';
import '../../../entity/token_entity.dart';
import '../../../net/error_handler.dart';
import '../../../service/token_service.dart';
import 'get_email_code_model.dart'; // 导入 VerifyEmailPage 页面

class VerifyEmailModel extends ChangeNotifier {
  final String email;
  final String verificationKey;
  final TextEditingController codeController = TextEditingController();
  final Dio _dio = Dio();
  bool _isLoading = false;
  String? _errorMessage;
  TokenEntity? _tokenEntity;
  GetEmailCodeModel _getEmailCodeModel = GetEmailCodeModel(); // 创建 GetEmailCodeModel 实例

  VerifyEmailModel({required this.email, required this.verificationKey}) {
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

  Future<void> verifyEmail() async {
    if (_tokenEntity == null || _tokenEntity?.accessToken == null) {
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
        options: Options(headers: {'token': _tokenEntity!.accessToken}),
      );

      if (response.data['code'] == 200 && response.data['data']['ret'] == true) {
        // Verification successful
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

  Future<void> resendVerificationCode(BuildContext context) async {
    // 调用 GetEmailCodeModel 中的 sendVerificationCode 方法重新发送验证码
    await _getEmailCodeModel.sendVerificationCode(context);
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
