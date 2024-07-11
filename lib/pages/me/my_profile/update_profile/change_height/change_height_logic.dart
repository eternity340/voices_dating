import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart'as dio;
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';

class ChangeHeightLogic {
  int selectedHeight = 170; // 默认身高为170

  Future<void> updateHeight(TokenEntity tokenEntity, UserDataEntity userData) async {
    try {
      dio.Response response = await Dio().post(
        'https://api.masonvips.com/v1/update_profile',
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        queryParameters: {
          'user[height]': selectedHeight.toString(),
        },
      );

      if (response.data['code'] == 200) {
        userData.height = selectedHeight.toString();
        Get.snackbar('Success', 'Height updated successfully');
        await Future.delayed(Duration(seconds: 2)); // 等待2秒以显示弹框
        Get.toNamed('/me/my_profile', arguments: {'token': tokenEntity, 'userData': userData});
      } else {
        Get.snackbar('Error', 'Failed to update height');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update height');
    }
  }
}
