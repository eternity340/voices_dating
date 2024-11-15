import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import '../../../../../net/api_constants.dart';
import '../../../../../net/dio.client.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../../service/app_service.dart';

class ChangeHeadlineController extends GetxController {
  final TextEditingController headlineController = TextEditingController();
  final AppService appService = Get.find<AppService>();
  var charCount = 0.obs;

  void updateCharCount(String text) {
    charCount.value = text.length;
  }

  Future<void> updateHeadline(TokenEntity tokenEntity, UserDataEntity userData) async {
    try {
      await DioClient.instance.requestNetwork<UserDataEntity>(
        method: Method.post,
        url: ApiConstants.updateProfile,
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        params: {
          'user[headline]': headlineController.text,
        },
        onSuccess: (data) async {
          if (data != null) {
            userData.headline = headlineController.text;
            await appService.updateStoredUserData({'headline': headlineController.text});
            Get.snackbar(ConstantData.successText, ConstantData.successUpdateProfile);
            await Future.delayed(Duration(seconds: 1));
            Get.toNamed(AppRoutes.meMyProfile, arguments: {
              'tokenEntity': tokenEntity,
              'userDataEntity': userData
            });
          } else {
            Get.snackbar(ConstantData.errorText, ConstantData.failedUpdateProfile);
          }
        },
        onError: (code, msg, data) {
          Get.snackbar(ConstantData.errorText, ConstantData.failedUpdateProfile);
        },
      );
    } catch (e) {
      Get.snackbar(ConstantData.errorText, ConstantData.failedUpdateProfile);
    }
  }


  @override
  void onClose() {
    headlineController.dispose();
    super.onClose();
  }
}
