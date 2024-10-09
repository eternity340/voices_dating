import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../components/custom_content_dialog.dart';
import '../../../net/dio.client.dart';
import '../../../entity/user_data_entity.dart';
import '../../../service/app_service.dart';
import '../../../net/api_constants.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final DioClient _dioClient = DioClient();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString errorMessage = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  Future<void> signIn() async {
    if (!_validateInputs()) return;

    isLoading.value = true;
    errorMessage.value = '';

    final params = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };

    try {
      final response = await _dioClient.requestNetwork<UserDataEntity>(
        method: Method.post,
        url: ApiConstants.signIn,
        params: params,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response != null) {
        await AppService.instance.saveUserData(userData: response);
        Get.offAllNamed('/home');
      } else {
        _handleError("User data is missing in the response.");
      }
    } catch (e) {
      _handleError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    emailError.value = emailController.text.isEmpty ? "Email cannot be empty!" : '';
    passwordError.value = passwordController.text.isEmpty ? "Password cannot be empty!" : '';
    return emailError.isEmpty && passwordError.isEmpty;
  }

  void _handleError(String message) {
    errorMessage.value = message;
    Get.dialog(
      CustomContentDialog(
        title: 'Login Error',
        content: message,
        buttonText: 'OK',
        onButtonPressed: () => Get.back(),
      ),
    );
  }
}
