import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:io';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';

class FeedbackController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments['token'];
  final UserDataEntity userData = Get.arguments['userData'];
  final ImagePicker _picker = ImagePicker();
  var selectedImagePath = ''.obs;
  final TextEditingController feedbackController = TextEditingController();

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

    final dioClient = dio.Dio();
    dioClient.options.headers['token'] = tokenEntity.accessToken;

    try {
      final response = await dioClient.post('https://api.masonvips.com/v1/upload_file', data: formData);
      if (response.data['code'] == 200) {
        return response.data['data'][0]['attachId'].toString();
      } else {
        print('Image upload failed: ${response.data['message']}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return null;
  }

  Future<void> submitFeedback() async {
    final attachId = await uploadImage();
    if (attachId == null) {
      print('Image upload failed');
      return;
    }

    final queryParams = {
      'subject': 'Test',
      'content': feedbackController.text,
      'email': userData.email,
      'username': userData.username,
      'attachId': attachId,
    };

    final dioClient = dio.Dio();
    dioClient.options.headers['token'] = tokenEntity.accessToken;

    try {
      final response = await dioClient.post(
        'https://api.masonvips.com/v1/feedback',
        queryParameters: queryParams,
      );
      if (response.data['code'] == 200) {
        print('Feedback submitted successfully');
      } else {
        print('Failed to submit feedback: ${response.data['message']}');
      }
    } catch (e) {
      print('Error submitting feedback: $e');
    }
  }
}
