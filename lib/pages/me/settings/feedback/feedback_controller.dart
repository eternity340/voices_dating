import 'package:first_app/constants/constant_data.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:first_app/utils/log_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:io';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../../../../net/dio.client.dart';

class FeedbackController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments['token'];
  final UserDataEntity userData = Get.arguments['userData'];
  final ImagePicker _picker = ImagePicker();
  var selectedImagePath = ''.obs;
  final TextEditingController feedbackController = TextEditingController();
  final DioClient dioClient = DioClient.instance;

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    }
  }

  Future<String?> uploadImage() async {
    if (selectedImagePath.value.isEmpty) {
      return null;
    }

    final file = File(selectedImagePath.value);
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
    });

    try {
      final response = await dioClient.requestNetwork<Map<String, dynamic>>(
        method: Method.post,
        url: ApiConstants.uploadFile,
        params: formData,
        options: dio.Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (data) {
          if (data != null && data['code'] == 200) {
            return data['data'][0]['attachId'].toString();
          }
        },
        onError: (code, msg, data) {
          LogUtil.e(message:msg);
        },
      );
      return response;
    } catch (e) {
      LogUtil.e(message:e.toString());
    }
    return null;
  }

  Future<void> submitFeedback() async {
    final attachId = await uploadImage();
    if (attachId == null) {
      LogUtil.e(message: 'Image upload failed');
      return;
    }

    final queryParams = {
      'subject': 'Test',
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