import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../../constants/constant_data.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import '../../../../../net/api_constants.dart';
import '../../../../../net/dio.client.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../../service/app_service.dart';

class ChangeUsernameController extends GetxController {
  final TextEditingController controller = TextEditingController();
  final AppService appService = Get.find<AppService>();

  int charCount = 0;

  Future<void> saveUsername(TokenEntity tokenEntity, UserDataEntity userData) async {
    final String newUsername = controller.text.trim();
    if (newUsername.isEmpty || newUsername.length > 16) {
      Get.snackbar(ConstantData.errorText, ConstantData.usernameCharacters);
      return;
    }

    try {
      await DioClient.instance.requestNetwork<UserDataEntity>(
        method: Method.post,
        url: ApiConstants.updateProfile,
        queryParameters: {'user[username]': newUsername},
        options: Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (data) async {
          if (data != null) {
            await appService.updateStoredUserData({'username': newUsername});
            Get.snackbar(ConstantData.successText, ConstantData.successUpdateProfile);
            await Future.delayed(Duration(seconds: 1));
            Get.toNamed(AppRoutes.meMyProfile, arguments: {
              'tokenEntity': tokenEntity,
              'userDataEntity': appService.selfUser
            });
          } else {
            Get.snackbar(ConstantData.errorText, ConstantData.failedUpdateProfile);
          }
        },
        onError: (code, msg, data) {
          Get.snackbar(ConstantData.errorText, msg);
        }
      );
    } catch (e) {
      Get.snackbar(ConstantData.errorText, e.toString());
    }
  }
}
