import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../entity/token_entity.dart';
import '../../../service/token_service.dart';

class ForgetPwdModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final dio.Dio _dio = dio.Dio();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ForgetPwdModel() {
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    try {
      await TokenService.instance.getTokenEntity();
    } catch (e) {
      _errorMessage = "Failed to initialize token: $e";
      notifyListeners();
    }
  }

  Future<void> sendResetEmail() async {
    final String email = emailController.text.trim();

    if (email.isEmpty) {
      _errorMessage = "Email cannot be empty";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final TokenEntity tokenEntity = await TokenService.instance.getTokenEntity();

      if (tokenEntity.accessToken == null) {
        throw Exception("No access token available");
      }

      final formData = dio.FormData.fromMap({
        'email': email,
      });

      final response = await _dio.post(
        'https://api.masonvips.com/v1/forget_password',
        data: formData,
        options: dio.Options(headers: {'token': tokenEntity.accessToken}),
      );

      if (response.data['code'] == 200) {
        final bool ret = response.data['data']['ret'];
        if (ret) {
          _showDialog("Success", "Reset email sent successfully");
        } else {
          _errorMessage = "Failed to send reset email";
        }
      } else {
        final errCode = response.data['errCode'];
        final errMsg = response.data['errMsg'];
        _errorMessage = "Error $errCode: $errMsg";
      }
    } catch (e) {
      _errorMessage = "Exception: $e";
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