import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:first_app/entity/token_entity.dart';
import 'package:first_app/entity/user_data_entity.dart';

class ChangeAgeController extends GetxController {
  // Scroll controllers for day, month, and year pickers
  final FixedExtentScrollController dayController = FixedExtentScrollController();
  final FixedExtentScrollController monthController = FixedExtentScrollController();
  final FixedExtentScrollController yearController = FixedExtentScrollController();

  // Current selected values
  var selectedDay = 1.obs;
  var selectedMonth = 1.obs;
  var selectedYear = DateTime.now().year.obs;

  @override
  void onInit() {
    super.onInit();
    // Set initial scroll positions
    dayController.jumpToItem(selectedDay.value - 1);
    monthController.jumpToItem(selectedMonth.value - 1);
    yearController.jumpToItem(DateTime.now().year - selectedYear.value);
  }

  @override
  void onClose() {
    // Dispose controllers
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.onClose();
  }

  Future<void> updateProfile(TokenEntity tokenEntity, UserDataEntity userData) async {
    try {
      // Calculate age based on selected year
      int currentYear = DateTime.now().year;
      int age = currentYear - selectedYear.value;

      // Format selected date
      String formattedDate = '${selectedYear.value}-${selectedMonth.value.toString().padLeft(2, '0')}-${selectedDay.value.toString().padLeft(2, '0')}';

      // Send API request
      dio.Response response = await dio.Dio().post(
        'https://api.masonvips.com/v1/update_profile',
        options: dio.Options(
          headers: {
            'token': tokenEntity.accessToken,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        queryParameters: {
          'user[birthday]': formattedDate,
          'user[age]': age.toString(),
        },
      );

      // Check response status
      if (response.data['code'] == 200) {
        userData.age = age.toString();
        Get.snackbar('Success', 'Profile updated successfully');
        await Future.delayed(Duration(seconds: 2)); // 等待2秒以显示弹框
        Get.toNamed('/me/my_profile', arguments: {'token': tokenEntity, 'userData': userData});
      } else {
        // Show error message
        Get.snackbar('Error', 'Failed to update profile');
      }
    } catch (e) {
      print('Exception caught: $e');
      Get.snackbar('Error', 'Failed to update profile');
    }
  }
}
