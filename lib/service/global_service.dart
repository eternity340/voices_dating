import 'dart:io';
import 'package:first_app/entity/user_data_entity.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../entity/list_user_entity.dart';
import '../net/dio.client.dart';
import '../utils/log_util.dart';
import '../utils/request_util.dart';

class GlobalService extends GetxController {
  RxBool needRefresh = false.obs;
  final DioClient dioClient = DioClient.instance;
  Rx<UserDataEntity?> userDataEntity = Rx<UserDataEntity?>(null);

  void setNeedRefresh(bool value) {
    needRefresh.value = value;
  }

  Future<String?> uploadFile(String filePath, String accessToken) async {
    if (filePath.isEmpty) {
      return null;
    }

    final file = File(filePath);
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
    });

    try {
      final response = await dioClient.dio.post(
        ApiConstants.uploadFile,
        data: formData,
        options: dio.Options(headers: {'token': accessToken}),
      );

      if (response.data['code'] == 200) {
        final data = response.data;
        if (data['data'].isNotEmpty) {
          return data['data'][0]['attachId'].toString();
        }
      }
      LogUtil.e(message:'${response.statusMessage}');
      return null;
    } catch (e) {
      LogUtil.e(message:e.toString());
      return null;
    }
  }

  Future<UserDataEntity?> getProfile(String userId, String accessToken) async {
    Map<String, dynamic> params = RequestUtil.getUserProfileMap(userId: userId);
      final result = await DioClient.instance.requestNetwork<UserDataEntity>(
        url: ApiConstants.getProfile,
        method: Method.get,
        queryParameters: params,
        options: dio.Options(headers: {'token': accessToken}),
        onSuccess: (result) {
          if (result != null) {
            userDataEntity.value = result;
            return result;
          }
          return null;
        },
      );
      return result;
  }



}