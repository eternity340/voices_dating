  import 'dart:ui';
  import 'package:dio/dio.dart';
  import 'package:voices_dating/net/interceptors/dio_inetercetptor.dart';
  import 'package:voices_dating/pages/home/home_page.dart';
  import 'package:voices_dating/pages/me/me_page.dart';
  import 'package:voices_dating/pages/message/message_page.dart';
  import 'package:voices_dating/pages/moments/moments_page.dart';
  import 'package:voices_dating/pages/voice/voice_page.dart';
  import 'package:voices_dating/routes/app_routes.dart';
  import 'package:voices_dating/service/app_service.dart';
  import 'package:voices_dating/service/global_service.dart';
  import 'package:voices_dating/service/im_service.dart';
  import 'package:voices_dating/service/token_service.dart';
  import 'package:voices_dating/utils/app_life_cycle_controller.dart';
  import 'package:voices_dating/utils/app_style_utils.dart';
  import 'package:voices_dating/utils/shared_preference_util.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:get/get.dart';
  import 'package:get_storage/get_storage.dart';
  import 'net/api_constants.dart';
  import 'net/dio.client.dart';
  import 'net/interceptors/log_interceptor.dart';
  import 'utils/log_util.dart';

  void main() async {
    await _initApp();
    WidgetsFlutterBinding.ensureInitialized();
    await GetStorage.init();
    Get.put(AppLifecycleController());
    runApp(const MyApp());
  }

  Future<void> _initApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await GetStorage.init();
    await SharedPreferenceUtil.instance.init();
    LogUtil.instance.init();
    Get.put(IMService().init());

    DioClient.instance.init(options: BaseOptions(
      connectTimeout: const Duration(milliseconds: connectionTimeout),
      receiveTimeout: const Duration(milliseconds: receiveTimeout),
      sendTimeout: const Duration(milliseconds: sendTimeout),
      baseUrl: ApiConstants.getBaseUrl(),
    ), interceptors: [DioLogInterceptor(),RequestInterceptor()]);

    await _initService();

    /*final globalService = Get.find<GlobalService>();
    await globalService.requestPermissions();*/
  }

  Future<void> _initService() async {
    await Get.putAsync(() => TokenService().init());
    await Get.putAsync(() => AppService().init());
    await Get.putAsync(() => GlobalService().init());
    Get.put(GlobalService());
  }

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
            title: 'Test App',
            theme: AppStyleUtils.lightTheme,
            debugShowCheckedModeBanner: false,
            enableLog: true,
            logWriterCallback: (message, {bool isError = false}) {
              LogUtil.d(message: message);
            },
            initialRoute: _getInitialRoute(),
            getPages: AppRoutes.routes,
            locale: PlatformDispatcher.instance.locale,
            onGenerateRoute: (settings) {
              if (['/home', '/moments', '/voice', '/message', '/me'].contains(settings.name)) {
                return GetPageRoute(
                  settings: settings,
                  page: () => _getPageForRoute(settings.name!),
                  transition: Transition.noTransition,
                );
              }
              return null;
            },
          );
        },
      );
    }

    String _getInitialRoute() {
      final appService = Get.find<AppService>();
      print(appService.isLogin);
      return appService.isLogin ? '/home' : '/welcome';
    }

    Widget _getPageForRoute(String route) {
      switch (route) {
        case '/home':
          return HomePage();
        case '/moments':
          return MomentsPage();
        case '/voice':
          return VoicePage();
        case '/message':
          return MessagePage();
        case '/me':
          return MePage();
        default:
          return HomePage(); // 默认返回首页
      }
    }
  }