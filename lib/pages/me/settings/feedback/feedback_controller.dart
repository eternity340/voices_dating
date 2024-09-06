import 'package:first_app/constants/constant_data.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:first_app/utils/log_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../../../../net/dio.client.dart';
import '../../../../service/global_service.dart';

class FeedbackController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments['tokenEntity'];
  final UserDataEntity userData = Get.arguments['userDataEntity'];
  final ImagePicker _picker = ImagePicker();
  var selectedImagePath = ''.obs;
  final TextEditingController feedbackController = TextEditingController();
  final DioClient dioClient = DioClient.instance;
  final GlobalService globalService = Get.find<GlobalService>();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    }
  }

  Future<void> submitFeedback() async {
    final attachId = await globalService.uploadFile(selectedImagePath.value, tokenEntity.accessToken!);
    if (attachId == null) {
      LogUtil.e(message: 'Image upload failed');
      return;
    }

    final queryParams = {
      'subject': 'My Feedback',
      'content': feedbackController.text,
      'email': userData.email,
      'username': userData.username,
      'attachId': attachId,
    };

    try {
      await dioClient.requestNetwork<void>(
        method: Method.post,
        url: ApiConstants.feedback,
        queryParameters: queryParams,
        options: dio.Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (_) {
          Get.snackbar(ConstantData.successText, ConstantData.feedBackSuccess);
        },
        onError: (code, msg , _) {
          Get.snackbar(ConstantData.errorText,msg);
        },
      );
    } catch (e) {
      LogUtil.e(message:e.toString());
      Get.snackbar(ConstantData.errorText, e.toString());
    }
  }
}
