import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:first_app/entity/user_data_entity.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:first_app/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:permission_handler/permission_handler.dart';
import '../entity/moment_entity.dart';
import '../net/dio.client.dart';
import '../utils/log_util.dart';
import '../utils/replace_word_util.dart';

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

  Future<UserDataEntity?> getUserProfile({required String userId,required String accessToken}) async {
    UserDataEntity? userData;

    await DioClient.instance.requestNetwork<UserDataEntity>(
      method: Method.get,
      url: ApiConstants.getProfile,
      queryParameters: {'profId': userId},
      options: Options(headers: {'token': accessToken}),
      onSuccess: (data) {
        if (data != null) {
          userData = data;
          ReplaceWordUtil replaceWordUtil = ReplaceWordUtil.getInstance();
          replaceWordUtil.getReplaceWord();
          userData!.username = replaceWordUtil.replaceWords(userData!.username);
          userData!.headline = replaceWordUtil.replaceWords(userData!.headline);
          userData!.about = replaceWordUtil.replaceWords(userData!.about);
        }
      },
      onError: (code, message, data) {
        if (code == 30001136) {
          CommonUtils.showSnackBar(message);
        } else {
          LogUtil.e(message: 'Failed to get profile: $message');
        }
      },
    );
    return userData;
  }

  //permission
  Future<Map<String, bool>> requestPermissions() async {
    Map<String, bool> permissionResults = {
      'camera': false,
      'microphone': false,
      'storage': false,
    };

    List<Permission> permissions = [
      Permission.camera,
      Permission.microphone,
    ];

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt < 33) {
        permissions.add(Permission.storage);
      }
    }

    Map<Permission, PermissionStatus> statuses = await permissions.request();

    statuses.forEach((permission, status) {
      if (status.isGranted) {
        switch (permission) {
          case Permission.camera:
            permissionResults['camera'] = true;
            break;
          case Permission.microphone:
            permissionResults['microphone'] = true;
            break;
          case Permission.storage:
            permissionResults['storage'] = true;
            break;
          default:
            break;
        }
      } else {
        LogUtil.e(message: '${permission.toString()} permission denied');
      }
    });
    if (permissionResults.values.every((granted) => granted)) {
      LogUtil.i(message: 'All permissions granted');
    } else {
      List<String> deniedPermissions = permissionResults.entries
          .where((entry) => !entry.value)
          .map((entry) => entry.key)
          .toList();
      LogUtil.e(message: 'The following permissions were denied: ${deniedPermissions.join(", ")}');
    }

    return permissionResults;
  }

  Future<Map<String, bool>> requestMediaPermissions() async {
    Map<String, bool> mediaPermissionResults = {
      'photos': false,
      'videos': false,
    };

    if (Platform.isAndroid) {
      await _handleAndroidMediaPermissions(mediaPermissionResults);
    } else if (Platform.isIOS) {
      await _handleIOSMediaPermissions(mediaPermissionResults);
    }

    return mediaPermissionResults;
  }

  Future<void> _handleAndroidMediaPermissions(Map<String, bool> results) async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      await _requestAndroidMediaPermissions(results);
    } else {
      _setLegacyAndroidMediaPermissions(results);
    }
  }

  Future<void> _requestAndroidMediaPermissions(Map<String, bool> results) async {
    Map<Permission, PermissionStatus> mediaStatuses = await [
      Permission.photos,
      Permission.videos,
    ].request();

    results['photos'] = mediaStatuses[Permission.photos]?.isGranted ?? false;
    results['videos'] = mediaStatuses[Permission.videos]?.isGranted ?? false;

    _logDeniedPermissions(mediaStatuses);
  }

  void _setLegacyAndroidMediaPermissions(Map<String, bool> results) {
    results['photos'] = true;
    results['videos'] = true;
  }

  Future<void> _handleIOSMediaPermissions(Map<String, bool> results) async {
    PermissionStatus photoStatus = await Permission.photos.request();
    results['photos'] = photoStatus.isGranted;
    results['videos'] = photoStatus.isGranted;
  }

  void _logDeniedPermissions(Map<Permission, PermissionStatus> statuses) {
    statuses.forEach((permission, status) {
      if (!status.isGranted) {
        LogUtil.e(message: '${permission.toString()} permission denied');
      }
    });
  }

  Future<bool> checkPermission(Permission permission) async {
    PermissionStatus status = await permission.status;
    if (!status.isGranted) {
      status = await permission.request();
    }
    return status.isGranted;
  }
}