import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
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

      if (response.statusCode == 200) {
        final data = response.data;
        userData = UserDataEntity.fromJson(data['data']);
        update();
      } else {
        print('获取用户数据失败');
      }
    } catch (e) {
      print('请求错误: $e');
    }
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
        'https://api.masonvips.com/v1/upload_picture',
        data: formData,
        options: dio.Options(
          headers: {
            'token': accessToken,
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        print(responseData);
        // 处理上传成功的情况
      } else {
        // 处理上传失败的情况
        print('上传失败');
      }
    } catch (e) {
      // 处理请求错误的情况
      print('请求错误: $e');
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

  Future<void> deletePhoto(String accessToken, String attachId) async {
    final dio.Dio dioInstance = dio.Dio();
    try {
      final response = await dioInstance.post(
        'https://api.masonvips.com/v1/delete_photo',
        queryParameters: {'attachId': attachId},
        options: dio.Options(
          headers: {
            'token': accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        print(responseData);
        // 处理删除成功的情况
        fetchUserData();
      } else {
        // 处理删除失败的情况
        print('删除失败');
      }
    } catch (e) {
      // 处理请求错误的情况
      print('请求错误: $e');
    }
  }


}
