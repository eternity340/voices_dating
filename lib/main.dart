import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:first_app/pages/pre_login/forget_pwd/forget_pwd_model.dart';
import 'package:first_app/pages/pre_login/sign_up/sign_up_model.dart';
import 'package:get/get.dart' as getx;
import 'package:provider/provider.dart';
import 'constants.dart';
import 'net/dio.client.dart';
import 'net/interceptors/log_interceptor.dart';
import 'routes/app_route.dart';
import 'pages/pre_login/welcome/welcome_page.dart';
import 'utils/log_util.dart'; // 确保路径正确

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  LogUtil logUtil = LogUtil.instance;

  DioClient dioClient = DioClient();
  dioClient.init(
    options: BaseOptions(
      baseUrl: "https://api.masonvips.com",
      connectTimeout: const Duration(milliseconds: connectionTimeout),
      receiveTimeout: const Duration(milliseconds: receiveTimeout),
      sendTimeout: const Duration(milliseconds: sendTimeout),
    ),
    interceptors: [DioLogInterceptor()],
  );

  runApp(MyApp(dioClient: dioClient));
}

class MyApp extends StatelessWidget {
  final DioClient dioClient;

  const MyApp({Key? key, required this.dioClient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ForgetPwdModel>(
          create: (_) => ForgetPwdModel(),
        ),
        ChangeNotifierProvider<SignUpModel>(
          create: (_) => SignUpModel(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // 使用设计稿尺寸
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return getx.GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Auth',
            theme: ThemeData(
              primaryColor: kPrimaryColor,
              scaffoldBackgroundColor: Colors.white,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.white,
                  backgroundColor: kPrimaryColor,
                  shape: const StadiumBorder(),
                  maximumSize: const Size(double.infinity, 56),
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: kPrimaryLightColor,
                iconColor: kPrimaryColor,
                prefixIconColor: kPrimaryColor,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            initialRoute: '/welcome',
            getPages: AppRoutes.routes,
            home: const WelcomePage(),
          );
        },
      ),
    );
  }
}
