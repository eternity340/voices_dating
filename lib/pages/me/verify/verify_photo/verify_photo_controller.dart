import 'package:voices_dating/constants/Constant_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:voices_dating/pages/me/me_page.dart';
import '../../../../components/custom_content_dialog.dart';
import '../../../../entity/base_entity.dart';
import '../../../../entity/ret_entity.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../../../../entity/user_photo_entity.dart';
import '../../../../net/api_constants.dart';
import '../../../../net/dio.client.dart';
import '../../../../constants/constant_data.dart';
import '../../../../routes/app_routes.dart';
import '../../../../service/app_service.dart';

class VerifyPhotoController extends GetxController {
  final TokenEntity tokenEntity;
  final UserDataEntity userData;

  VerifyPhotoController({required this.tokenEntity, required this.userData});

  Rx<File?> image = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      checkVerificationStatus();
    });*/
  }

  void checkVerificationStatus() {
    switch (userData.verified) {
      case '1':
        showApprovalVerificationDialog();
        break;
      case '2':
        showPendingVerificationDialog();
        break;
      case '3':
        showRejectedVerificationDialog();
        break;
      default:
      // 如果状态不是 1, 2, 或 3，可能需要额外的处理
        break;
    }
  }
  void showApprovalVerificationDialog() {
    Get.dialog(
      CustomContentDialog(
        title: ConstantData.verificationApprovalTitle,
        content: ConstantData.verificationApprovalMessage,
        buttonText: ConstantData.gotItText,
        onButtonPressed: () => Get.to(()=>MePage(),arguments: {
          'tokenEntity': tokenEntity,
          'userDataEntity': userData,
          'isMeActive': true
        }),
      ),
      barrierDismissible: false,
    );
  }

  void showPendingVerificationDialog() {
    Get.dialog(
      CustomContentDialog(
        title: ConstantData.verificationPendingTitle,
        content: ConstantData.verificationPendingMessage,
        buttonText: ConstantData.gotItText,
        onButtonPressed: () => Get.toNamed(
            AppRoutes.meVerify,
            arguments: {
              'tokenEntity': tokenEntity,
              'userDataEntity': userData},
        ),
      ),
    );
  }

  void showRejectedVerificationDialog() {
    Get.dialog(
      CustomContentDialog(
        title: ConstantData.verificationRejectedTitle,
        content: ConstantData.verificationRejectedMessage,
        buttonText: ConstantData.yesText,
        onButtonPressed: () => Get.back(),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  Future<void> uploadImage() async {
    if (image.value == null) {
      Get.snackbar(
        ConstantData.errorText,
        ConstantData.uploadFailed,
        backgroundColor: Color(0xFFF8F8F9),
        colorText: Colors.black,
      );
      return;
    }

    try {
      final file = await dio.MultipartFile.fromFile(image.value!.path);
      final Map<String, dynamic> formMap = {
        'file': file,
        'photoType': 3,
        'maskInfo': 'mask information,json format',
      };

      DioClient.instance.requestNetwork(
        method: Method.post,
        url: ApiConstants.uploadPicture,
        params: formMap,
        options: dio.Options(
          headers: {
            'token': tokenEntity.accessToken,
            'Content-Type': 'multipart/form-data',
          },
        ),
        onSuccess: (dynamic data) async {
            Get.snackbar(
              ConstantData.successText,
              ConstantData.uploadSuccess,
              backgroundColor: Color(0xFFF8F8F9),
              colorText: Colors.black,
            );
            await AppService.instance.updateStoredUserData({'verified': '2'});
            userData.verified = '2';
            await Future.delayed(Duration(seconds: 2));
            Get.back();
            Get.offAllNamed(
              AppRoutes.me,
              arguments: {'tokenEntity': tokenEntity, 'userDataEntity': userData},
            );
        },
        onError: (code, msg, data) {
          if (code == 30002000) {
            Get.snackbar(
              ConstantData.verifyNotMatchTitle,
              msg,
              backgroundColor: Color(0xFFF8F8F9),
              colorText: Colors.black,
              margin: EdgeInsets.all(10),
              borderRadius: 8,
              duration: Duration(seconds: 10),
              messageText: Text(
                msg,
                style: ConstantStyles.verifyPhotoTextStyle,
              ),
            );
          } else if (code == 30001034) {
            Get.snackbar(
              ConstantData.noticeText,
              msg,
              backgroundColor: Color(0xFFF8F8F9),
              colorText: Colors.black,
              duration: Duration(seconds: 3),
            );
            Future.delayed(Duration(seconds: 3), () {
              Get.back();
            });
          } else {
            Get.snackbar(
              ConstantData.errorText,
              msg,
              backgroundColor: Color(0xFFF8F8F9),
              colorText: Colors.black,
            );
          }
        },
      );
    } catch (e) {
      Get.snackbar(
        ConstantData.errorText,
        e.toString(),
        backgroundColor: Color(0xFFF8F8F9),
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


}
