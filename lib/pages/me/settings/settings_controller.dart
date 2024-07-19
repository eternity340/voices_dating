import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../components/custom_message_dialog.dart';

class SettingsController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments['token'];
  final UserDataEntity userData = Get.arguments['userData'];

  Future<void> signOut() async {
    final dio = Dio();
    try {
      final response = await dio.post(
        'https://api.masonvips.com/v1/signout',
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
      );
      if (response.data['code'] == 200) {
        Get.snackbar('Success', 'Sign out successful',
            snackPosition: SnackPosition.BOTTOM);
        Get.offAllNamed('/welcome');
      } else {
        Get.snackbar('Error', 'Failed to sign out',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while signing out',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void showCustomMessageDialog(BuildContext context, VoidCallback onYesPressed) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomMessageDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          onYesPressed: onYesPressed,
        );
      },
    );
  }
}
