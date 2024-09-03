import 'package:first_app/net/api_constants.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/ret_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../net/dio.client.dart';
import '../../../service/global_service.dart';

class PhotoController extends GetxController {
  late TokenEntity tokenEntity;
  late UserDataEntity userData;
  final GlobalService globalService = Get.find<GlobalService>();

  @override
  void onInit() {
    super.onInit();
    tokenEntity = Get.arguments['token'] as TokenEntity;
    userData = Get.arguments['userData'] as UserDataEntity;
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
      await uploadPhoto(accessToken, image);
      await fetchUserData();
    }
  }

  Future<void> uploadPhoto(String accessToken, XFile image) async {
    final dio.Dio dioInstance = dio.Dio();
    final dio.FormData formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(image.path),
      'maskInfo': 'mask information,json format',
      'photoType': '1',
    });

    try {
      final response = await dioInstance.post(
        ApiConstants.uploadPicture,
        data: formData,
        options: dio.Options(
          headers: {
            'token': accessToken,
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.data[ConstantData.code] == 200) {
        Get.snackbar(ConstantData.successText, ConstantData.uploadSuccess);
      } else {
        Get.snackbar(ConstantData.errorText, ConstantData.failedUpdateProfile);
      }
    } catch (e) {
      Get.snackbar(ConstantData.errorText, e.toString());
    }
  }

  Future<void> deletePhoto(String attachId) async {
    try {
      await DioClient.instance.requestNetwork<RetEntity>(
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
      await DioClient.instance.requestNetwork<Map<String, dynamic>>(
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
          if (data != null && data['code'] == 200) {
            Get.snackbar(
              ConstantData.successText, ConstantData.avatarSetSuccess);
            await fetchUserData();
          } else {
            Get.snackbar(ConstantData.errorText, ConstantData.avatarSetFailed);
          }
        },
        onError: (code, msg, data) {
          Get.snackbar(ConstantData.errorText,msg);
        },
      );
    } catch (e) {
      Get.snackbar(ConstantData.errorText,e.toString());
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


}
