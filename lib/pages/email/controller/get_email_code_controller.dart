import 'package:dio/dio.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../net/dio.client.dart';
import '../../../entity/token_entity.dart';
import '../../../service/token_service.dart';
import '../page/verify_email_page.dart';

class GetEmailCodeController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = RxString('');
  final FocusNode emailFocusNode = FocusNode();
  final RxBool isEmailFocused = false.obs;
  final RxString selectedDomain = '@gmail.com'.obs;
  final List<String> emailDomains = [
    '@gmail.com',
    '@yahoo.com',
    '@outlook.com',
    '@icloud.com',
    '@qq.com'
  ];

  @override
  void onInit() {
    super.onInit();
    emailFocusNode.addListener(() {
      isEmailFocused.value = emailFocusNode.hasFocus;
    });
  }


  void onDomainChanged(String? newValue) {
    if (newValue != null) {
      selectedDomain.value = newValue;
    }
  }

  String get fullEmail => '${emailController.text}${selectedDomain.value}';

  Future<void> sendVerificationCode() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final TokenEntity tokenEntity = await TokenService.instance.getTokenEntity();
      if (tokenEntity.accessToken == null) {
        throw Exception("No access token available");
      }

      await DioClient.instance.requestNetwork<Map<String, dynamic>>(
        method: Method.get,
        url: ApiConstants.emailVerificationCode,
        queryParameters: {'email': fullEmail},
        options: Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (data) {
          final verificationKey = data?['key'];
          Get.to(() => VerifyEmailPage(email: fullEmail, verificationKey: verificationKey));
        },
        onError: (code, msg, data) {
          errorMessage.value = "Error: $msg";
          _showErrorDialog(errorMessage.value);
        },
      );
    } catch (e) {
      errorMessage.value = "Unexpected exception: $e";
      _showErrorDialog(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    emailFocusNode.dispose();
    super.onClose();
  }

}
