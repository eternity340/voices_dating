import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../../../constants/constant_data.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import '../../../../../net/api_constants.dart';
import '../../../../../net/dio.client.dart';
import '../../../../../routes/app_routes.dart';

class ChangeHeightController extends GetxController {
  late TokenEntity tokenEntity;
  late UserDataEntity userData;
  int selectedHeight = 170;

  void init(TokenEntity token, UserDataEntity user) {
    tokenEntity = token;
    userData = user;
  }

  void updateHeight() async {
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
        queryParameters: {
          'user[height]': selectedHeight.toString(),
        },
        onSuccess: (updatedUserData) async {
          if (updatedUserData != null) {
            userData.height = updatedUserData.height;
            Get.snackbar(ConstantData.successText, ConstantData.successUpdateProfile);
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
          Get.snackbar(ConstantData.errorText, ConstantData.failedUpdateProfile);
        },
      );
    } catch (e) {
      Get.snackbar(ConstantData.errorText, ConstantData.failedUpdateProfile);
    }
  }

}
