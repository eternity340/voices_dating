import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voices_dating/service/token_service.dart';
import '../entity/im_message_entity.dart';
import '../routes/app_routes.dart';
import '../utils/log_util.dart';

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final RxBool _showNotifications = true.obs;
  bool get showNotifications => _showNotifications.value && !_isInChatPage();
  set showNotifications(bool value) => _showNotifications.value = value;

  static NotificationService get to => Get.find();

  // 添加需要过滤的关键词列表
  final List<String> _filteredKeywords = [
    'result',
    'dart Task',
    'inputData',
    'Elapsed time',
    // 可以根据需要添加更多关键词
  ];

  bool _isInChatPage() {
    final currentRoute = Get.currentRoute;
    return currentRoute == AppRoutes.message || currentRoute == AppRoutes.messagePrivateChat;
  }

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      LogUtil.d(message: 'notification payload: $payload');
      try {
        final messageData = json.decode(payload);
        final message = IMMessageEntity.fromJson(messageData);
        // 导航到聊天页面
        Get.offNamed(
          AppRoutes.message,
          arguments: {
            'tokenEntity': await TokenService.instance.getTokenEntity()
          },
        );
      } catch (e) {
        LogUtil.e(message: 'Error parsing notification payload: $e');
      }
    }
  }

  Future<void> showNotification(String title, String body, {String? payload}) async {
    // 检查是否应该显示这个通知
    if (!_shouldShowNotification(title, body)) {
      LogUtil.d(message: "Notification suppressed: $title - $body");
      return;
    }

    if (!showNotifications) {
      LogUtil.d(message: "Notifications are currently disabled or user is in chat page");
      return;
    }
    LogUtil.d(message: "showNotification called with title: $title, body: $body");

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/launcher_icon',
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await localNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
      LogUtil.d(message: "Notification should be displayed now");
    } catch (e) {
      LogUtil.e(message: "Error showing notification: $e");
    }
  }

  bool _shouldShowNotification(String title, String body) {
    // 检查标题和内容是否包含需要过滤的关键词
    for (var keyword in _filteredKeywords) {
      if (title.toLowerCase().contains(keyword.toLowerCase()) ||
          body.toLowerCase().contains(keyword.toLowerCase())) {
        return false;
      }
    }
    return true;
  }

  Future<void> requestNotificationPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      LogUtil.d(message: 'Notification permission status: $status');
    }
  }
}
