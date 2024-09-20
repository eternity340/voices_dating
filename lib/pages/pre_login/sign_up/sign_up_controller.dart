import 'package:common_utils/common_utils.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../../../components/custom_content_dialog.dart';
import '../../../constants/constant_data.dart';
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
  }

  @override
  void onInit() {
    super.onInit();
    usernameController.text = user.username ?? '';
    passwordController.text = user.password ?? '';
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
      user.username = usernameController.text;
      user.password = passwordController.text;

      final Map<String, dynamic> queryParameters = user.toJson();

      LogUtil.d('User data being sent: ${user.toJson()}');

      await DioClient.instance.requestNetwork<dynamic>(
        method: Method.post,
        url: ApiConstants.signUP,
        queryParameters: queryParameters,
        options: dio.Options(
          headers: {
            'token': await TokenService.instance.getToken(),
          },
        ),
        onSuccess: (data) {
          print('Sign up successful. Response data: $data');
          Get.toNamed(AppRoutes.welcome, arguments: user);
        },
        onError: (code, msg, data) {
          print('Sign up error. Code: $code, Message: $msg, Data: $data');
          if (code == 30001051) {
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
              _showCustomDialog(
                ConstantData.errorText,
                errorMessage.value,
                ConstantData.cancelText,
                    () => Get.back(),
              );
            }
          } else {
            errorMessage.value = msg;
            _showCustomDialog(
              'Sign Up Error',
              errorMessage.value,
              ConstantData.cancelText,
                  () => Get.back(),
            );
          }
        },
      );
    } catch (e) {
      print('Exception during sign up: $e');
      errorMessage.value = "exception: $e";
      _showCustomDialog('Error', errorMessage.value, 'OK', () => Get.back());
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
      await DioClient.instance.requestNetwork<dynamic>(
        method: Method.post,
        url: ApiConstants.signUP,
        params: userData,
        options: dio.Options(
          headers: {
            'Content-Type': 'application/json',
            'token': tokenEntity.accessToken,
          },
        ),
        onSuccess: (data) {
          Get.toNamed(AppRoutes.welcome, arguments: user);
        },
        onError: (code, msg, data) {
          errorMessage.value = msg;
          _showCustomDialog(
              ConstantData.registerFailed,
              errorMessage.value,
              ConstantData.cancelText,
              () => Get.back());
        },
      );
    } catch (e) {
      errorMessage.value = "exception: $e";
      _showCustomDialog(
          ConstantData.errorText,
          errorMessage.value,
          ConstantData.cancelText,
          () => Get.back());
    } finally {
      isLoading.value = false;
    }
  }

  void _showCustomDialog(String title, String content, String buttonText, VoidCallback onButtonPressed) {
    Get.dialog(
      CustomContentDialog(
        title: title,
        content: content,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
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
