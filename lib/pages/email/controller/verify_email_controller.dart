import 'package:first_app/net/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../entity/User.dart';
import '../../../entity/token_entity.dart';
import '../../../net/dio.client.dart';
import '../../../net/error_handler.dart';
import '../../../service/token_service.dart';
import '../../../utils/common_utils.dart';

class VerifyEmailController extends GetxController {
  final String email;
  final String verificationKey;
  final TextEditingController codeController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final DioClient dioClient = DioClient.instance;

  VerifyEmailController({required this.email, required this.verificationKey}) {
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    try {
      await TokenService.instance.getTokenEntity();
    } catch (e) {
      errorMessage.value = "Failed to initialize token: $e";
    }
  }

  Future<void> verifyEmail() async {
    final String code = codeController.text.trim();

    if (verificationKey.isEmpty) {
      errorMessage.value = "Verification key is empty.";
      CommonUtils.showSnackBar(errorMessage.value);
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final TokenEntity tokenEntity = await TokenService.instance.getTokenEntity();
      if (tokenEntity.accessToken == null) {
        throw Exception("No access token available");
      }

      await dioClient.requestNetwork<Map<String, dynamic>>(
        method: Method.post,
        url: ApiConstants.verifyEmail,
        queryParameters: {
          'email': email,
          'code': code,
          'key': verificationKey,
        },
        options: Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (data) {
          if (data?['ret'] == true) {
            User user = User(email: email);
            Get.toNamed('/verify_success', arguments: {
              'message': data?['message'] ?? 'Verification successful',
              'user': user,
            });
          } else {
            CommonUtils.showSnackBar(errorMessage.value);
          }
        },
        onError: (code, msg, data) {
          errorMessage.value = "Error: $msg";
          CommonUtils.showSnackBar(errorMessage.value);
        },
      );
    } catch (e) {
      final netError = ExceptionHandler.handleException(e);
      errorMessage.value = netError.msg;
      CommonUtils.showSnackBar(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  /*Future<void> resendVerificationCode() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final TokenEntity tokenEntity = await TokenService.instance.getTokenEntity();

      if (tokenEntity.accessToken == null) {
        throw Exception("No access token available");
      }

      await DioClient.instance.requestNetwork<Map<String, dynamic>>(
        method: Method.get,
        url: 'https://api.masonvips.com/v1/email_verification_code',
        queryParameters: {'email': email},
        options: Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (data) {
          final newVerificationKey = data?['key'];
          if (newVerificationKey != null) {
            Get.find<VerifyEmailController>().verificationKey = newVerificationKey;
            CommonUtils.showSnackBar('Verification code resent successfully', snackBarType: SnackBarType.success);
          } else {
            errorMessage.value = "Failed to get new verification key";
            CommonUtils.showSnackBar(errorMessage.value);
          }
        },
        onError: (code, msg, data) {
          errorMessage.value = "Error: $msg";
          CommonUtils.showSnackBar(errorMessage.value);
        },
      );
    } catch (e) {
      final netError = ExceptionHandler.handleException(e);
      errorMessage.value = netError.msg;
      CommonUtils.showSnackBar(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }*/

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }
}
