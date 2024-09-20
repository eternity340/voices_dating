import 'package:first_app/entity/user_photo_entity.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../../../components/custom_message_dialog.dart';
import '../../../components/photo_dialog.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/ret_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../net/dio.client.dart';
import '../../../routes/app_routes.dart';
import '../../../service/global_service.dart';

class PhotoController extends GetxController {
  late TokenEntity tokenEntity;
  late UserDataEntity userData;
  final GlobalService globalService = Get.find<GlobalService>();
  final DioClient dioClient = DioClient.instance;
  final RxMap<String, bool> uploadingPhotos = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
    userData = Get.arguments['userDataEntity'] as UserDataEntity;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    await globalService.refreshUserData(tokenEntity.accessToken.toString());
    userData = globalService.userDataEntity.value!;
    update();
  }

  Future<void> pickAndUploadPhoto(String accessToken, ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      final String localPath = image.path;
      uploadingPhotos[localPath] = true;
      update();

      await uploadPhoto(accessToken, image);

      uploadingPhotos.remove(localPath);
      await fetchUserData();
    }
  }

  Future<void> uploadPhoto(String accessToken, XFile image) async {
    final dio.FormData formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(image.path),
      'maskInfo': 'mask information,json format',
      'photoType': '1',
    });

    await dioClient.requestNetwork<List<dynamic>>(
      method: Method.post,
      url: ApiConstants.uploadPicture,
      params: formData,
      options: dio.Options(
        headers: {
          'token': accessToken,
          'Content-Type': 'multipart/form-data',
        },
      ),
      onSuccess: (data) async {
        if (data != null && data.isNotEmpty) {
          final List<UserPhotoEntity> photos = data.map((item) => UserPhotoEntity.fromJson(item)).toList();
          if (photos.isNotEmpty) {
            final photo = photos[0];
            Get.snackbar(ConstantData.successText, ConstantData.uploadSuccess);
            print('Uploaded photo: AttachId: ${photo.attachId}, URL: ${photo.url}');

            // 上传成功后立即刷新数据
            await fetchUserData();
          } else {
            Get.snackbar(ConstantData.errorText, ConstantData.failedUpdateProfile);
          }
        } else {
          Get.snackbar(ConstantData.errorText, ConstantData.failedUpdateProfile);
        }
      },
      onError: (code, msg, data) {
        Get.snackbar(ConstantData.errorText, msg);
      },
      formParams: true,
    );
  }

  Future<void> deletePhoto(String attachId) async {
    try {
      await dioClient.requestNetwork<RetEntity>(
        method: Method.post,
        url: ApiConstants.deletePhoto,
        queryParameters: {
          'attachId': attachId,
        },
        options: dio.Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
        onSuccess: (data) async {
          if (data != null && data.ret == true) {
            Get.snackbar(ConstantData.successText, ConstantData.deletePhotoSuccess);
            await fetchUserData();
          } else {
            Get.snackbar(ConstantData.errorText,ConstantData.failedDeletePhoto,);
          }
        },
        onError: (code, msg, data) {
          Get.snackbar(ConstantData.errorText, msg);
        },
      );
    } catch (e) {
      Get.snackbar(ConstantData.errorText,e.toString());
    }
  }


  Future<void> setAvatar(String attachId) async {
    try {
      await dioClient.requestNetwork<RetEntity>(
        method: Method.post,
        url: ApiConstants.setAvatar,
        queryParameters: {
          'attachId': attachId,
        },
        options: dio.Options(
          headers: {
            'token': tokenEntity.accessToken,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        onSuccess: (data) async {
          if (data != null && data.ret == true) {
            Get.snackbar(ConstantData.successText, ConstantData.avatarSetSuccess);
            await fetchUserData();
            Get.offNamed(AppRoutes.me, arguments: {
              'tokenEntity': tokenEntity,
              'userDataEntity': globalService.userDataEntity.value,
            });
          } else {
            Get.snackbar(ConstantData.errorText, ConstantData.avatarSetFailed);
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


  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      return result.isGranted;
    }
  }

  void showPhotoDialog(String photoUrl, String attachId) {
    final PhotoController controller = Get.find<PhotoController>();

    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) {
        return PhotoDialog(
          photoUrl: photoUrl,
          attachId: attachId,
          onDelete: () async {
            await controller.deletePhoto(attachId);
            Navigator.of(context).pop();
          },
          onSetting: () {
            showDialog(
              context: Get.context!,
              builder: (BuildContext context) {
                return CustomMessageDialog(
                  title: Text(ConstantData.setAvatarTitle),
                  content: Text(ConstantData.setAvatarContent),
                  onYesPressed: () async {
                    Navigator.of(context).pop();
                    await controller.setAvatar(attachId);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void navigateToMePage() {
    Get.offAllNamed(AppRoutes.me, arguments: {
      'tokenEntity': tokenEntity,
      'userDataEntity': userData,
    });
  }
}
