import 'dart:io';
import 'package:dio/dio.dart';
import 'package:first_app/entity/user_data_entity.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../entity/moment_entity.dart';
import '../net/dio.client.dart';
import '../utils/log_util.dart';

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

  Future<UserDataEntity?> getUserProfile({required String userId, required String accessToken}) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        ApiConstants.getProfile,
        queryParameters: {'profId': userId},
        options: Options(headers: {'token': accessToken}),
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData['code'] == 200 && jsonData['data'] != null) {
          return UserDataEntity.fromJson(jsonData['data']);
        } else {
          LogUtil.e(message: '${jsonData['message']}');
        }
      } else {
        LogUtil.e(message: '${response.statusCode}');
      }
    } catch (e) {
      LogUtil.e(message:'$e');
    }
    return null;
  }

  Future<List<MomentEntity>> getMoments({required String userId, required String accessToken}) async {
    List<MomentEntity> moments = [];

    await DioClient.instance.requestNetwork<List<dynamic>>(
      method: Method.get,
      url: ApiConstants.timelines,
      queryParameters: {
        'profId': userId
      },
      options: Options(headers: {'token': accessToken}),
      onSuccess: (data) {
        if (data != null) {
          moments = data.map((json) => MomentEntity.fromJson(json)).toList();
        }
      },
      onError: (code, message, data) {
        LogUtil.e(message: 'Failed to get moments: $message');
      },
    );

    return moments;
  }

  Future<UserDataEntity?> getUserData({required String accessToken}) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        ApiConstants.getProfile,
        options: Options(headers: {'token': accessToken}),
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData['code'] == 200 && jsonData['data'] != null) {
          return UserDataEntity.fromJson(jsonData['data']);
        } else {
          LogUtil.e(message: '${jsonData['message']}');
        }
      } else {
        LogUtil.e(message: '${response.statusCode}');
      }
    } catch (e) {
      LogUtil.e(message:'$e');
    }
    return null;
  }

  Future<void> refreshUserData(String accessToken) async {
    UserDataEntity? updatedUserData = await getUserData(
      accessToken: accessToken,
    );
    if (updatedUserData != null) {
      userDataEntity.value = updatedUserData;
    }
  }

}