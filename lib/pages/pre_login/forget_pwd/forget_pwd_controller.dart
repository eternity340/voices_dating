import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/custom_message_dialog.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/token_entity.dart';
import '../../../net/dio.client.dart';
import '../../../service/token_service.dart';
import '../../../entity/ret_entity.dart';

class ForgetPwdController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = RxString('');

  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  final DioClient dioClient = DioClient.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    try {
      await TokenService.instance.getTokenEntity();
    } catch (e) {
      LogUtil.e(e.toString());
    }
  }

  Future<void> sendResetEmail() async {
    final String email = emailController.text.trim();
    if (email.isEmpty) {
      _errorMessage.value = ConstantData.emailEmpty;
      return;
    }
    _isLoading.value = true;
    try {
      final TokenEntity tokenEntity = await TokenService.instance.getTokenEntity();
      final Map<String, dynamic> params = {
        'email': email,
        'indle':1
      };
      final Options options = Options(headers: {'token': tokenEntity.accessToken});
      await dioClient.requestNetwork<RetEntity>(
        method: Method.post,
        url: ApiConstants.forgetPassword,
        params: params,
        options: options,
        onSuccess: (data) {
          if (data?.ret == true) {
            showSuccessDialog();
          } else {
            showFailedDialog();
          }
        },
        onError: (code, msg, data) {
          LogUtil.e(msg);
        },
      );
    } catch (e) {
      LogUtil.e(e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  void showSuccessDialog() {
    Get.dialog(
      CustomMessageDialog(
        title: const Text(ConstantData.successText),
        content: const Text(ConstantData.sendSuccess),
        onYesPressed: () {
          Get.offAllNamed(AppRoutes.welcome);
        },
      ),
      barrierDismissible: false,
    );
  }

  void showFailedDialog() {
    Get.dialog(
      CustomMessageDialog(
        title: const Text(ConstantData.failedText),
        content: const Text(ConstantData.sendFailed),
        onYesPressed: () {
          Get.offAllNamed(AppRoutes.welcome);
        },
      ),
      barrierDismissible: false,
    );
  }
}
