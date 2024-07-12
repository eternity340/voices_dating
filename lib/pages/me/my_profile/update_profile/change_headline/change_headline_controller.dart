import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';

class ChangeHeadlineController extends GetxController {
  final TextEditingController headlineController = TextEditingController();
  var charCount = 0.obs;

  void updateCharCount(String text) {
    charCount.value = text.length;
  }

  Future<void> updateHeadline(TokenEntity tokenEntity, UserDataEntity userData) async {
    try {
      // Send API request
      dio.Response response = await Dio().post(
        'https://api.masonvips.com/v1/update_profile',
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'user[headline]': headlineController.text,
        },
      );
      // Check response status
      if (response.data['code'] == 200) {
        userData.headline = headlineController.text;
        Get.snackbar('Success', 'Headline updated successfully');
        await Future.delayed(Duration(seconds: 2)); // 等待2秒以显示弹框
        Get.toNamed('/me/my_profile', arguments: {'token': tokenEntity, 'userData': userData});
      } else {
        // Show error message
        Get.snackbar('Error', 'Failed to update headline');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update headline');
    }
  }

  @override
  void onClose() {
    headlineController.dispose();
    super.onClose();
  }
}
