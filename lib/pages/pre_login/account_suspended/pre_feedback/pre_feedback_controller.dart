import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants/constant_data.dart';
import '../../../../net/api_constants.dart';
import '../../../../net/dio.client.dart';
import '../../../../service/global_service.dart';
import '../../../../service/token_service.dart';
import '../../../../utils/log_util.dart';

class PreFeedbackController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var selectedImagePath = ''.obs;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  var selectedTopic = ''.obs;
  final DioClient dioClient = DioClient.instance;
  final GlobalService globalService = Get.find<GlobalService>();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    }
  }

  Future<void> submitFeedback() async {
    String? attachId;
    if (selectedImagePath.value.isNotEmpty) {
      attachId = await globalService.uploadFile(selectedImagePath.value);
      if (attachId == null) {
        LogUtil.e(message: 'Image upload failed');
        // 考虑是否要在这里返回，或者继续提交反馈
        // return;
      }
    }

    final queryParams = {
      'subject': selectedTopic.value,
      'content': contentController.text,
      'email': emailController.text,
      'username': usernameController.text,
      'phone': phoneController.text,
    };

    // 如果有附件ID，添加到查询参数中
    if (attachId != null) {
      queryParams['attachId'] = attachId;
    }

    try {
      await dioClient.requestNetwork<void>(
        method: Method.post,
        url: ApiConstants.feedback,
        queryParameters: queryParams,
        options: Options(headers: {'token': await TokenService.instance.getToken()}),
        onSuccess: (_) {
          Get.snackbar(ConstantData.successText, ConstantData.feedBackSuccess);
        },
        onError: (code, msg , _) {
          Get.snackbar(ConstantData.errorText, msg);
        },
      );
    } catch (e) {
      LogUtil.e(message: e.toString());
      Get.snackbar(ConstantData.errorText, e.toString());
    }
  }
}
