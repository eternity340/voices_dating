import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:first_app/pages/pre_login/forget_pwd/forget_pwd_model.dart';
import 'package:first_app/pages/pre_login/sign_up/sign_up_model.dart';
import 'package:get/get.dart' as getx;
import 'package:provider/provider.dart';
import 'constants.dart';
import 'routes/app_route.dart';
import 'pages/pre_login/welcome/welcome_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        designSize: Size(375, 812), // 使用设计稿尺寸
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
