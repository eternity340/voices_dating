import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../../../entity/User.dart';
import '../../../entity/token_entity.dart';
import '../../../net/dio.client.dart';
import '../../../service/token_service.dart';
import 'google_recaptcha/recaptcha_sheet.dart';

class SignUpController extends GetxController {
  final User user;
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;
  RxString confirmPasswordErrorMessage = ''.obs;

  RxBool isLoading = false.obs;
  RxString emailErrorMessage = ''.obs;
  RxString usernameErrorMessage = ''.obs;
  RxString passwordErrorMessage = ''.obs;
  RxString errorMessage = ''.obs;

  SignUpController(this.user) {
    _initializeToken();
  }

  @override
  void onInit() {
    super.onInit();
    usernameController.text = user.username ?? '';
    passwordController.text = user.password ?? '';
  }

  Future<void> _initializeToken() async {
    try {
      await TokenService.instance.getTokenEntity();
    } catch (e) {
      errorMessage.value = "Failed to initialize token: $e";
    }
  }

  void setUsername(String username) {
    user.username = username;
    usernameErrorMessage.value = '';
  }

  void setPassword(String password) {
    user.password = password;
    passwordErrorMessage.value = '';
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void setConfirmPassword(String confirmPassword) {
    confirmPasswordErrorMessage.value = '';
    if (confirmPassword != passwordController.text) {
      confirmPasswordErrorMessage.value = 'Passwords do not match';
    }
  }

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final TokenEntity tokenEntity = await TokenService.instance.getTokenEntity();

      if (tokenEntity.accessToken == null) {
        throw Exception("No access token available");
      }

      user.username = usernameController.text;
      user.password = passwordController.text;
      final Map<String, dynamic> userData = user.toJson();

      await DioClient.instance.requestNetwork<dynamic>(
        method: Method.post,
        url: 'https://api.masonvips.com/v1/signup',
        params: userData,
        options: dio.Options(
          headers: {
            'Content-Type': 'application/json',
            'token': tokenEntity.accessToken,
          },
        ),
        onSuccess: (data) {
          Get.toNamed('/welcome', arguments: user);
        },
        onError: (code, msg, data) {
          if (code == 30001051 && data is Map<String, dynamic>) {
            final siteKey = data['siteKey'] as String?;
            if (siteKey != null) {
              showRecaptcha(
                Get.context!,
                siteKey,
                    (token) {
                  _retrySignUpWithRecaptcha(token);
                },
              );
            } else {
              errorMessage.value = "Invalid reCAPTCHA site key";
              _showErrorDialog(errorMessage.value);
            }
          } else {
            errorMessage.value = msg;
            _showErrorDialog(errorMessage.value);
          }
        },
      );
    } catch (e) {
      errorMessage.value = "exception: $e";
      _showErrorDialog(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _retrySignUpWithRecaptcha(String recaptchaToken) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final TokenEntity tokenEntity = await TokenService.instance.getTokenEntity();

      if (tokenEntity.accessToken == null) {
        throw Exception("No access token available");
      }

      final Map<String, dynamic> userData = user.toJson();
      userData['token'] = recaptchaToken; // 添加 reCAPTCHA token 到请求数据中

      await DioClient.instance.requestNetwork<dynamic>(
        method: Method.post,
        url: 'https://api.masonvips.com/v1/signup',
        params: userData,
        options: dio.Options(
          headers: {
            'Content-Type': 'application/json',
            'token': tokenEntity.accessToken,
          },
        ),
        onSuccess: (data) {
          Get.toNamed('/welcome', arguments: user);
        },
        onError: (code, msg, data) {
          errorMessage.value = msg;
          _showErrorDialog(errorMessage.value);
        },
      );
    } catch (e) {
      errorMessage.value = "exception: $e";
      _showErrorDialog(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Sign Up Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
