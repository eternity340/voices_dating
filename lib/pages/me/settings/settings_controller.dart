import 'package:dio/dio.dart';
import 'package:first_app/constants/constant_data.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../components/custom_message_dialog.dart';
import '../../../net/dio.client.dart';
import '../../../service/app_service.dart';

class SettingsController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments['token'];
  final UserDataEntity userData = Get.arguments['userData'];

  Future<void> signOut() async {
    try {
      await DioClient.instance.requestNetwork(
        method: Method.post,
        url: ApiConstants.signOut,
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
        onSuccess: (data) async {
          await AppService.instance.forceLogout();
        },
        onError: (code, msg, data) {
          Get.snackbar(ConstantData.errorText, msg);
        },
      );
    } catch (e) {
      Get.snackbar(ConstantData.errorText, e.toString());
    }
  }

  void showCustomMessageDialog(BuildContext context, VoidCallback onYesPressed) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomMessageDialog(
          title: Text(ConstantData.signOut),
          content: Text(ConstantData.signOutText),
          onYesPressed: () {
            Navigator.of(context).pop();
            signOut();
          },
        );
      },
    );
  }
}