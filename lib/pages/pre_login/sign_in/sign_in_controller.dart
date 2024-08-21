import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/user_data_entity.dart';
import '../../../net/dio.client.dart';
import '../../../service/app_service.dart';
import '../../../service/token_service.dart';
import '../../../entity/token_entity.dart';
import '../../../utils/shared_preference_util.dart';
import '../../home/home_page.dart';

class SignInController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DioClient dioClient = DioClient.instance;

  bool _isLoading = false;
  String? _emailErrorMessage;
  String? _passwordErrorMessage;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get emailErrorMessage => _emailErrorMessage;
  String? get passwordErrorMessage => _passwordErrorMessage;
  String? get errorMessage => _errorMessage;

  @override
  void onInit() {
    super.onInit();
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    try {
      await TokenService.instance.getTokenEntity();
    } catch (e) {
      _errorMessage = "Failed to initialize token: $e";
      update();
    }
  }

  Future<void> signIn() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty) {
      _emailErrorMessage = "Email cannot be empty!";
      update();
      return;
    } else {
      _emailErrorMessage = null;
    }

    if (password.isEmpty) {
      _passwordErrorMessage = "Password cannot be empty!";
      update();
      return;
    } else {
      _passwordErrorMessage = null;
    }

    _isLoading = true;
    _errorMessage = null;
    update();

    try {
      final TokenEntity tokenEntity = await TokenService.instance.getTokenEntity();

      if (tokenEntity.accessToken == null) {
        throw Exception("No access token available");
      }

      final params = Dio.FormData.fromMap({
        'email': email,
        'password': password,
      });

      final options = Dio.Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          'token': tokenEntity.accessToken,
        },
      );

      await dioClient.requestNetwork<UserDataEntity>(
        method: Method.post,
        url: 'https://api.masonvips.com/v1/signin',
        params: params,
        options: options,
        onSuccess: (userData) {
          AppService.instance.isLogin = true;
          AppService.instance.saveUserData(userData: userData!);
          SharedPreferenceUtil.instance.setValue(key: SharedPresKeys.isLogin, value: true);
          Get.offAll(() => HomePage(), arguments: {
            'token': tokenEntity,
            'userData': userData,
          });
        },
        onError: (code, msg, data) {
          if (code == ConstantData.errorCodeInvalidEmailOrPassword) {
            _errorMessage = msg;
          } else {
            _errorMessage = "error: $msg";
          }
          _showErrorDialog(_errorMessage);
        },
        formParams: true,  // Ensure this is true when using FormData
      );
    } catch (e) {
      _errorMessage = "exception: $e";
      print('Exception occurred: $_errorMessage');
      _showErrorDialog(_errorMessage);
    } finally {
      _isLoading = false;
      update();
    }
  }

  void _showErrorDialog(String? message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Login Error'),
        content: Text(message ?? 'An unknown error occurred.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
