import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

class AppLifecycleController extends GetxController with WidgetsBindingObserver {
  RxBool isAppInForeground = true.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initializeWorkmanager();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  void _initializeWorkmanager() async {
    await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: true
    );

    // 注册一个周期性任务
    await Workmanager().registerPeriodicTask(
      "periodicTask",
      "periodicTask",
      frequency: Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        isAppInForeground.value = true;
        _onResumed();
        break;
      case AppLifecycleState.paused:
        isAppInForeground.value = false;
        _onPaused();
        break;
      case AppLifecycleState.inactive:
        isAppInForeground.value = false;
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      // 这些状态可能需要特殊处理
        break;
    }
  }

  void _onResumed() {
    // 应用回到前台时的操作
    print("App resumed");
    // 可以在这里执行一些恢复操作，比如刷新数据
  }

  void _onPaused() {
    // 应用进入后台时的操作
    print("App paused");
    // 可以在这里执行一些保存状态或清理操作
  }

  // 注册一次性任务的方法
  void scheduleOneOffTask() {
    Workmanager().registerOneOffTask(
      "oneOffTask",
      "oneOffTask",
      initialDelay: Duration(seconds: 10),
    );
  }

  // 取消所有任务的方法
  void cancelAllTasks() {
    Workmanager().cancelAll();
  }
}

// 全局回调函数，需要在 main.dart 或其他全局可访问的地方定义
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'periodicTask':
        print("Executing periodic task");
        // 在这里执行你的周期性后台任务
        break;
      case 'oneOffTask':
        print("Executing one-off task");
        // 在这里执行你的一次性后台任务
        break;
    }
    return Future.value(true);
  });
}
