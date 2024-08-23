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

  final DioClient _dioClient = DioClient.instance;

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
      final response = await _dioClient.requestNetwork<Map<String, dynamic>>(
        method: Method.post,
        url: 'https://api.masonvips.com/v1/upload_file',
        params: formData,
        options: dio.Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (data) {
          if (data != null && data['code'] == 200) {
            return data['data'][0]['attachId'].toString();
          }
        },
        onError: (code, msg, data) {
          LogUtil.e(message: 'Image upload failed: $msg');
        },
      );
      return response;
    } catch (e) {
      LogUtil.e(message: 'Error uploading image: $e');
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
      await _dioClient.requestNetwork<void>(
        method: Method.post,
        url: 'https://api.masonvips.com/v1/feedback',
        queryParameters: queryParams,
        options: dio.Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (_) {
          LogUtil.i(message: 'Feedback submitted successfully');
        },
        onError: (code, msg, _) {
          LogUtil.e(message: 'Failed to submit feedback: $msg');
        },
      );
    } catch (e) {
      LogUtil.e(message: 'Error submitting feedback: $e');
    }
  }
}