import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:voices_dating/net/dio.client.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:voices_dating/entity/ret_entity.dart';
import 'package:voices_dating/service/app_service.dart';
import 'package:voices_dating/service/token_service.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:voices_dating/constants/constant_data.dart';
import '../../../../components/custom_content_dialog.dart';

class DeleteAccountController extends GetxController {
  final DioClient dioClient = DioClient.instance;

  void deleteAccount(String password, {bool permanently = false}) async {
    try {
      await dioClient.requestNetwork<RetEntity>(
        method: Method.post,
        url: ApiConstants.deleteAccount,
        params: {
          'password': password,
          'permanently': permanently ? 1 : 0,
        },
        options: Options(headers: {'token': await TokenService.instance.getToken()}),
        onSuccess: (data) {
          if (data?.ret == true) {
            Get.snackbar(
                ConstantData.successText, permanently
                ? ConstantData.accountDeletedMessage
                : ConstantData.accountDisabledMessage
            );
            AppService.instance.forceLogout();
            Get.offAllNamed(AppRoutes.welcome);
          } else {
            Get.snackbar(
                ConstantData.failedText, permanently
                ? ConstantData.failedToDeleteAccount
                : ConstantData.failedToDisableAccount
            );
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

  void showConfirmationDialog(String password, {bool permanently = false}) {
    Get.dialog(
      CustomContentDialog(
        title: permanently
            ? ConstantData.permanentlyDeleteAccountTitle
            : ConstantData.disableAccountTitle,
        content: permanently
            ? ConstantData.permanentlyDeleteAccountConfirmation
            : ConstantData.disableAccountConfirmation,
        buttonText: ConstantData.confirmText,
        onButtonPressed: () {
          Get.back(); // Close the dialog
          deleteAccount(password, permanently: permanently);
        },
      ),
    );
  }
}
