import 'package:first_app/net/api_constants.dart';
import 'package:first_app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart' as dio;
import '../../../components/bottom_options.dart';
import '../../../components/custom_message_dialog.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';

class AddMomentController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
  final UserDataEntity userDataEntity = Get.arguments['userDataEntity'] as UserDataEntity;
  final textEditingController = TextEditingController();
  final imageFiles = <XFile?>[null].obs;

  void showBottomOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BottomOptions(
          onFirstPressed: () async {
            Navigator.pop(context);
            await handleCameraPermission(index);
          },
          onSecondPressed: () async {
            Navigator.pop(context);
            await handleStoragePermission(index);
          },
          onCancelPressed: () {
            Navigator.pop(context);
          },
          firstText: ConstantData.takePhotoText,
          secondText: ConstantData.fromAlbumText,
        );
      },
    );
  }

  Future<void> handleCameraPermission(int index) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        updateImageFiles(index, pickedFile);
      }
    } else {
      // Handle permission denied
    }
  }

  Future<void> handleStoragePermission(int index) async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        updateImageFiles(index, pickedFile);
      }
    } else {
      // Handle permission denied
    }
  }

  void updateImageFiles(int index, XFile pickedFile) {
    if (index == imageFiles.length - 1) {
      imageFiles[index] = pickedFile;
      imageFiles.add(null);
    } else {
      imageFiles[index] = pickedFile;
    }
  }

  Future<void> uploadMoment() async {
    final content = textEditingController.text;
    final formData = dio.FormData();
    formData.fields.add(MapEntry('content', content));
    for (var imageFile in imageFiles) {
      if (imageFile != null) {
        final file = await dio.MultipartFile.fromFile(imageFile.path, filename: imageFile.name);
        formData.files.add(MapEntry('file', file));
      }
    }

    try {
      final response = await dio.Dio().post(
        ApiConstants.uploadTimeline,
        data: formData,
        options: dio.Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        showSuccessDialog();
      } else {
        Get.snackbar('Error', 'Failed to upload moment');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while uploading the moment');
    }
  }

  void showSuccessDialog() {
    Get.dialog(
      CustomMessageDialog(
        title: Text(ConstantData.successText),
        content: Text(ConstantData.momentUploadSuccess),
        onYesPressed: () {
          Get.offAllNamed(AppRoutes.moments,
              arguments: {
                'tokenEntity': tokenEntity,
                'userDataEntity': userDataEntity});
        },
      ),
    );
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }
}
