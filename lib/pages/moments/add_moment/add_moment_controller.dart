import 'package:voices_dating/net/api_constants.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:voices_dating/service/global_service.dart';
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
import '../../../net/dio.client.dart';

class AddMomentController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
  final UserDataEntity userDataEntity = Get.arguments['userDataEntity'] as UserDataEntity;
  final textEditingController = TextEditingController();
  final imageFiles = <XFile?>[null].obs;
  final DioClient dioClient = DioClient.instance;

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

    for (var i = 0; i < imageFiles.length; i++) {
      if (imageFiles[i] != null) {
        final file = await dio.MultipartFile.fromFile(
            imageFiles[i]!.path,
            filename: imageFiles[i]!.name
        );
        formData.files.add(MapEntry('file', file));
      }
    }

    try {
      await dioClient.requestNetwork<dynamic>(
        method: Method.post,
        url: ApiConstants.uploadTimeline,
        params: formData,
        options: dio.Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
          contentType: 'multipart/form-data',
        ),
        formParams: true,
        onSuccess: (data) {
          //showSuccessDialog();
          Get.offAllNamed(AppRoutes.moments,
              arguments: {
                'tokenEntity': tokenEntity,
                'userDataEntity': userDataEntity});
          Get.snackbar(ConstantData.successText, 'Upload Moment Success!');
        },
        onError: (code, msg, data) {
          Get.snackbar('Error', msg );
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred while uploading the moment');
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
