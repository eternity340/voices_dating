import 'package:dio/dio.dart';
import 'package:first_app/constants/constant_data.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:first_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:first_app/entity/token_entity.dart';
import 'package:first_app/entity/user_data_entity.dart';
import '../../../../../net/dio.client.dart';
import '../../../../../service/app_service.dart';

class ChangeAgeController extends GetxController {
  final FixedExtentScrollController dayController = FixedExtentScrollController();
  final FixedExtentScrollController monthController = FixedExtentScrollController();
  final FixedExtentScrollController yearController = FixedExtentScrollController();
  final AppService appService = Get.find<AppService>();
  var selectedDay = 1.obs;
  var selectedMonth = 1.obs;
  var selectedYear = DateTime.now().year.obs;

  @override
  void onInit() {
    super.onInit();
    dayController.jumpToItem(selectedDay.value - 1);
    monthController.jumpToItem(selectedMonth.value - 1);
    yearController.jumpToItem(DateTime.now().year - selectedYear.value);
  }

  @override
  void onClose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.onClose();
  }

  Future<void> updateProfile(TokenEntity tokenEntity, UserDataEntity userData) async {
    try {
      int currentYear = DateTime.now().year;
      int age = currentYear - selectedYear.value;
      String formattedDate =
          '${selectedYear.value}-${selectedMonth.value.toString().padLeft(2, '0')}-${selectedDay.value.toString().padLeft(2, '0')}';
      await DioClient.instance.requestNetwork<UserDataEntity>(
        method: Method.post,
        url: ApiConstants.updateProfile,
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        queryParameters: {
          'user[birthday]': formattedDate,
          'user[age]': age.toString(),
        },
        onSuccess: (data) async {
          if (data != null) {
            userData.age = age.toString();
            await appService.updateStoredUserData({'birthday':formattedDate});
            await appService.updateStoredUserData({'age': age});
            Get.snackbar(ConstantData.successText, ConstantData.successUpdateProfile);
            await Future.delayed(Duration(seconds: 1));
            Get.toNamed(AppRoutes.meMyProfile,
                arguments: {
                  'tokenEntity': tokenEntity,
                  'userDataEntity': userData
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
      Get.snackbar(ConstantData.errorText, ConstantData.failedUpdateProfile);
    }
  }

}
