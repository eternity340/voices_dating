  import 'dart:io';
  import 'package:device_info_plus/device_info_plus.dart';
  import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
  import 'package:voices_dating/entity/user_data_entity.dart';
  import 'package:voices_dating/net/api_constants.dart';
  import 'package:voices_dating/service/token_service.dart';
  import 'package:voices_dating/utils/common_utils.dart';
  import 'package:get/get.dart';
  import 'package:dio/dio.dart' as dio;
  import 'package:permission_handler/permission_handler.dart';
  import '../entity/moment_entity.dart';
  import '../entity/option_entity.dart';
  import '../entity/upload_file_entity.dart';
  import '../net/dio.client.dart';
  import '../utils/log_util.dart';

  class GlobalService extends GetxService {
    static GlobalService get to => Get.find();

    RxBool needRefresh = false.obs;
    final DioClient dioClient = DioClient.instance;
    Rx<UserDataEntity?> userDataEntity = Rx<UserDataEntity?>(null);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    Future<GlobalService> init() async {
      await requestPermissions();
      await initNotifications();
      return this;
    }

    Future<void> initNotifications() async {
      await _requestNotificationPermissions();
      await _initializeLocalNotifications();
    }

    Future<void> _requestNotificationPermissions() async {
      if (Platform.isAndroid) {
        final status = await Permission.notification.request();
        LogUtil.d(message: 'Notification permission status: $status');
      } else if (Platform.isIOS) {
        final status = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        LogUtil.d(message: 'iOS Notification permission status: $status');
      }
    }

    Future<void> _initializeLocalNotifications() async {
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
      final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
          // 处理通知点击事件
          LogUtil.d(message: 'Notification clicked: ${notificationResponse.payload}');
        },
      );
    }

    void setNeedRefresh(bool value) {
      needRefresh.value = value;
    }

    Future<String?> uploadFile(String filePath) async {
      if (filePath.isEmpty) {
        return null;
      }

      final file = File(filePath);
      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      });

      String? attachId;

      await dioClient.requestNetwork<dynamic>(
        method: Method.post,
        url: ApiConstants.uploadFile,
        params: formData,
        options: dio.Options(headers: {'token': await TokenService.instance.getToken()}),
        onSuccess: (dynamic response) {
          if (response is List && response.isNotEmpty) {
            // 假设列表中的第一个元素是我们需要的数据
            var fileData = response[0];
            if (fileData is Map<String, dynamic>) {
              UploadFileEntity uploadedFile = UploadFileEntity.fromJson(fileData);
              attachId = uploadedFile.attachId;
            }
          } else if (response is Map<String, dynamic> &&
              response['code'] == 200 &&
              response['data'] is List &&
              response['data'].isNotEmpty) {

            UploadFileEntity uploadedFile = UploadFileEntity.fromJson(response['data'][0]);
            attachId = uploadedFile.attachId;
          }
        },
        onError: (code, msg, data) {
          LogUtil.e(message: 'Failed to upload file: $msg');
        },
        formParams: true,
      );
      return attachId;
    }



    Future<List<MomentEntity>> getMoments({required String userId, required String accessToken}) async {
      List<MomentEntity> moments = [];

      await dioClient.requestNetwork<List<dynamic>>(
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

    Future<UserDataEntity?> getUserData() async {
      await dioClient.requestNetwork<UserDataEntity>(
        method: Method.get,
        url: ApiConstants.getProfile,
        options: Options(headers: {'token': await TokenService.instance.getToken()}),
        onSuccess: (data) {
          if (data != null) {
            userDataEntity.value = data;
          }
        },
        onError: (code, message, data) {
          LogUtil.e(message: 'Failed to get user data: $message');
        },
      );
      return userDataEntity.value;
    }

    Future<void> refreshUserData() async {
      await getUserData();
    }


    Future<UserDataEntity?> getUserProfile({required String userId}) async {
      UserDataEntity? userData;

      await dioClient.requestNetwork<UserDataEntity>(
        method: Method.get,
        url: ApiConstants.getProfile,
        queryParameters: {'profId': userId},
        options: Options(headers: {'token': await TokenService.instance.getToken()}),
        onSuccess: (data) {
          if (data != null) {
            userData = data;
           /* ReplaceWordUtil replaceWordUtil = ReplaceWordUtil.getInstance();
            replaceWordUtil.getReplaceWord();
            userData!.username = replaceWordUtil.replaceWords(userData!.username);
            userData!.headline = replaceWordUtil.replaceWords(userData!.headline);
            userData!.about = replaceWordUtil.replaceWords(userData!.about);*/
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

    Future<List<OptionEntity>> getLanguageOptions() async {
      try {
        List<OptionEntity> languageOptions = [];

        await DioClient.instance.requestNetwork<Map<String, dynamic>>(
          method: Method.get,
          url: ApiConstants.getProfileOptions,
          options: Options(headers: {'token': await TokenService.instance.getToken()}),
          onSuccess: (data) {
            if (data != null && data['language'] != null) {
              final languageData = data['language'] as List<dynamic>;
              languageOptions = languageData
                  .map((lang) => OptionEntity(
                id: lang['id'] as String,
                label: lang['label'] as String,
              ))
                  .toList();
            } else {
              throw Exception('failed');
            }
          },
          onError: (code, message, data) {
            LogUtil.e(message:  message);
            throw Exception(message);
          },
        );

        return languageOptions;
      } catch (e) {
        LogUtil.e(message:e.toString());
        rethrow;
      }
    }

    Future<String?> getLocalIpAddress() async {
      try {
        final interfaces = await NetworkInterface.list(
          includeLoopback: false,
          type: InternetAddressType.IPv4,
        );

        for (var interface in interfaces) {
          for (var addr in interface.addresses) {
            // 过滤掉本地回环地址
            if (addr.address != '127.0.0.1') {
              return addr.address;
            }
          }
        }
      } catch (e) {
        LogUtil.e(message: 'Error getting local IP address: $e');
      }
      return null;
    }

    Future<void> printDeviceIpAddress() async {
      String? ipAddress = await getLocalIpAddress();
      if (ipAddress != null) {
        print('Device IP Address: $ipAddress');
      } else {
        print('Unable to get device IP address');
      }
    }

  }


