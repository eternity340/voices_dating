import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';

class PhotoController extends GetxController {
  late TokenEntity tokenEntity;
  late UserDataEntity userData;

  @override
  void onInit() {
    super.onInit();
    tokenEntity = Get.arguments['token'] as TokenEntity;
    userData = Get.arguments['userData'] as UserDataEntity;
    fetchUserData(); // 初始化时获取用户数据
  }

  Future<void> fetchUserData() async {
    final dio.Dio dioInstance = dio.Dio();

    try {
      final response = await dioInstance.get(
        'https://api.masonvips.com/v1/get_profile',
        options: dio.Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
      );

      if (response.data[ConstantData.code] == 200) {
        final data = response.data;
        userData = UserDataEntity.fromJson(data['data']);
        update(); // 更新 UI
      } else {
        print('Failed to obtain user data');
      }
    } catch (e) {
      print('request error: $e');
    }
  }

  Future<void> pickAndUploadPhoto(String accessToken, ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      await uploadPhoto(accessToken, image);
      await fetchUserData(); // 上传后刷新用户数据
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
        'https://api.masonvips.com/v1/upload_picture',
        data: formData,
        options: dio.Options(
          headers: {
            'token': accessToken,
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.data[ConstantData.code] == 200) {
        Get.snackbar(
          'Success',
          'Upload successful!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        print('upload failed');
      }
    } catch (e) {
      print('request error: $e');
    }
  }

  Future<void> deletePhoto(String accessToken, String attachId) async {
    final dio.Dio dioInstance = dio.Dio();

    try {
      final response = await dioInstance.post(
        'https://api.masonvips.com/v1/delete_photo',
        queryParameters: {
          'attachId': attachId,
        },
        options: dio.Options(
          headers: {
            'token': accessToken,
          },
        ),
      );

      if (response.data[ConstantData.code] == 200) {
        Get.snackbar(
          'Success',
          'Photo deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        await fetchUserData(); // 删除后刷新用户数据
      } else {
        print('delete failed');
      }
    } catch (e) {
      print('request error: $e');
    }
  }

  Future<void> setAvatar(String accessToken,String attachId, ) async {
    final dio.Dio dioInstance = dio.Dio();
    try {
      final response = await dioInstance.post(
        'https://api.masonvips.com/v1/set_avatar',
        queryParameters: {
          'attachId': attachId,
        },
        options: dio.Options(
          headers: {
            'token': tokenEntity.accessToken,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data[ConstantData.code] == 200) {
        Get.snackbar(
          'Success',
          'Avatar set successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        await fetchUserData(); // 刷新用户数据
      } else {
        print('Set avatar failed');
      }
    } catch (e) {
      print('request error: $e');
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
