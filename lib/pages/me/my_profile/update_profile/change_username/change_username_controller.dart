import 'package:first_app/entity/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../../constants/constant_data.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import '../../../../../net/api_constants.dart';
import '../../../../../net/dio.client.dart';
import '../../../../../routes/app_routes.dart';

class ChangeUsernameController {
  final TextEditingController controller = TextEditingController();

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
        queryParameters: {'username': newUsername},
        options: Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (data) async {
          if (data != null) {
            userData.username = newUsername;
            Get.snackbar('Success', 'Change username success');
            await Future.delayed(Duration(seconds: 2));
            Get.toNamed(AppRoutes.meMyProfile, arguments: {
              'token': tokenEntity,
              'userData': userData
            });
          } else {
            Get.snackbar(ConstantData.errorText, ConstantData.failedUpdateProfile);
          }
        },
        onError: (code, msg, data) {
          Get.snackbar(ConstantData.errorText, msg);
        },
      );
    } catch (e) {
      Get.snackbar(ConstantData.errorText, e.toString());
    }
  }

}
