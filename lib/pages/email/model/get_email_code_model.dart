import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../net/error_handler.dart';
import '../../../service/token_service.dart';
import '../page/verify_email_page.dart';

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

  Future<void> sendVerificationCode(BuildContext context) async {
    if (_accessToken == null) {
      _errorMessage = "No access token available.";
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
        _errorMessage = "Error: ${response.statusMessage}";
        print('Error: ${response.statusMessage}');
        _showErrorDialog(context, _errorMessage!);
      }
    } on DioError catch (e) {
      final netError = ExceptionHandler.handleException(e);
      _errorMessage = netError?.msg;
      print(_errorMessage);
      _showErrorDialog(context, _errorMessage!);
    } catch (e) {
      _errorMessage = "Unexpected exception: $e";
      print(_errorMessage);
      _showErrorDialog(context, _errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
