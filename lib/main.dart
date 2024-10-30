import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// 导入自定义的页面、服务、工具类等
import 'package:voices_dating/net/interceptors/dio_inetercetptor.dart';
import 'package:voices_dating/pages/home/home_page.dart';
import 'package:voices_dating/pages/me/me_page.dart';
import 'package:voices_dating/pages/message/message_page.dart';
import 'package:voices_dating/pages/moments/moments_page.dart';
import 'package:voices_dating/pages/voice/voice_room_page.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:voices_dating/service/app_service.dart';
import 'package:voices_dating/service/global_service.dart';
import 'package:voices_dating/service/im_service.dart';
import 'package:voices_dating/service/token_service.dart';
import 'package:voices_dating/utils/app_life_cycle_controller.dart';
import 'package:voices_dating/utils/app_style_utils.dart';
import 'package:voices_dating/utils/shared_preference_util.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:voices_dating/net/dio.client.dart';
import 'package:voices_dating/net/interceptors/log_interceptor.dart';
import 'package:voices_dating/utils/log_util.dart';


void main() async {
  await _initApp();
  runApp(const MyApp());
}

// 初始化应用程序
Future<void> _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await SharedPreferenceUtil.instance.init();
  LogUtil.instance.init();

  // 初始化并注册IM服务
  Get.put(await IMService().init());

  // 初始化Dio客户端
  DioClient.instance.init(options: BaseOptions(
    connectTimeout: const Duration(milliseconds: connectionTimeout),
    receiveTimeout: const Duration(milliseconds: receiveTimeout),
    sendTimeout: const Duration(milliseconds: sendTimeout),
    baseUrl: ApiConstants.getBaseUrl(),
  ), interceptors: [DioLogInterceptor(), RequestInterceptor()]);

  await _initService();
  Get.put(AppLifecycleController());
}

// 初始化服务
Future<void> _initService() async {
  await Get.putAsync(() => TokenService().init()); // 初始化并注册Token服务
  await Get.putAsync(() => AppService().init()); // 初始化并注册App服务
  await Get.putAsync(() => GlobalService().init()); // 初始化并注册全局服务
  Get.put(GlobalService()); // 再次注册全局服务（可能是为了确保单例）
}

// 主应用程序Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(355, 810),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Voices Dating',
          theme: AppStyleUtils.lightTheme,
          debugShowCheckedModeBanner: false,
          enableLog: true,
          logWriterCallback: (message, {bool isError = false}) {
            LogUtil.d(message: message);
          },
          initialRoute: _getInitialRoute(),
          getPages: AppRoutes.routes,
          locale: PlatformDispatcher.instance.locale,
          onGenerateRoute: _generateRoute,
        );
      },
    );
  }

  // 获取初始路由
  String _getInitialRoute() {
    final appService = Get.find<AppService>();
    print(appService.isLogin);
    if(appService.isLogin){
      IMService.instance.connect();
    }
    return appService.isLogin ? '/home' : '/welcome'; // 根据登录状态返回不同的初始路由
  }

  // 生成路由
  Route<dynamic>? _generateRoute(RouteSettings settings) {
    if (['/home', '/moments', '/voice', '/message', '/me'].contains(settings.name)) {
      return GetPageRoute(
        settings: settings,
        page: () => _getPageForRoute(settings.name!),
        transition: Transition.noTransition,
      );
    }
    return null;
  }

  // 根据路由名获取对应的页面Widget
  Widget _getPageForRoute(String route) {
    switch (route) {
      case '/home':
        return HomePage();
      case '/moments':
        return MomentsPage();
      case '/voice':
        return VoiceRoomPage();
      case '/message':
        return MessagePage();
      case '/me':
        return MePage();
      default:
        return HomePage(); // 默认返回首页
    }
  }
}
