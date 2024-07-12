import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';

class ChangeUsernameLogic {
  final TextEditingController controller = TextEditingController();

  int charCount = 0;

  Future<void> saveUsername(TokenEntity tokenEntity, UserDataEntity userData) async {
    final String newUsername = controller.text.trim();
    if (newUsername.isEmpty || newUsername.length > 16) {
      Get.snackbar('Error', 'Username must be 16 characters or fewer');
      return;
    }

    try {
      final response = await Dio().post(
        'https://api.masonvips.com/v1/change_username',
        queryParameters: {'username': newUsername},
        options: Options(headers: {'token': tokenEntity.accessToken}),
      );

      if (response.data['code'] == 200 && response.data['data']['ret'] == true) {
        userData.username = newUsername;
        Get.snackbar('Success', 'Change username success');
        await Future.delayed(Duration(seconds: 2)); // 等待2秒以显示弹框
        Get.toNamed('/me/my_profile', arguments: {'token': tokenEntity, 'userData': userData});
      } else {
        Get.snackbar('Error', 'Failed to change username');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to change username');
    }
  }
}
